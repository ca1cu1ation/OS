#!/bin/sh

# 是否开启详细模式（verbose）
verbose=false
if [ "x$1" = "x-v" ]; then
    verbose=true
    out=/dev/stdout
    err=/dev/stderr
else
    out=/dev/stdout
    err=/dev/stderr
fi

## make & makeopts
# 检查系统中是否存在 gmake（GNU make）
if gmake --version > /dev/null 2>&1; then
    make=gmake;
else
    make=make;
fi
# make 参数：静默模式，不打印目录信息，并行编译
makeopts="--quiet --no-print-directory -j"

# 从 Makefile 中打印某个变量的值
make_print() {
    echo `$make $makeopts print-$1`
}

echo ">>>>>>>>>> 构建内核中 >>>>>>>>>>"
$make
echo ">>>>>>>>>> 内核构建完成 >>>>>>>>>>"


## 工具别名
awk='awk'
bc='bc'
date='date'
grep='grep'
rm='rm -f'
sed='sed'

## 符号表路径
sym_table='obj/kernel.sym'

## gdb / qemu 相关变量
gdb="$(make_print GDB)"
gdbport='1234'
gdb_in="$(make_print GRADE_GDB_IN)"
qemu="$(make_print qemu)"
qemu_out="$(make_print GRADE_QEMU_OUT)"

# 检查 qemu 是否支持 -gdb 参数
if $qemu -nographic -help | grep -q '^-gdb'; then
    qemugdb="-gdb tcp::$gdbport"
else
    qemugdb="-s -p $gdbport"
fi

# 默认超时时间与分数设置
default_timeout=30
default_pts=5
pts=5
part=0
part_pos=0
total=0
total_pos=0

# 更新总得分
update_score() {
    total=`expr $total + $part`
    total_pos=`expr $total_pos + $part_pos`
    part=0
    part_pos=0
}

# 获取当前时间（秒.纳秒）
get_time() {
    echo `$date +%s.%N 2> /dev/null`
}

# 显示最终成绩
show_final() {
    update_score
    echo "================================="
    echo "总得分: $total/$total_pos"
    echo "================================="
    if [ $total -lt $total_pos ]; then
        exit 1
    fi
}

# 通过测试
pass() {
    echo "[通过] $1"
    part=`expr $part + $pts`
    part_pos=`expr $part_pos + $pts`
}

# 未通过测试
fail() {
    echo "[失败] $1"
    part_pos=`expr $part_pos + $pts`
}

# 运行 QEMU 测试伙伴系统
run_qemu() {
    echo ">>> 正在运行 QEMU 进行 Buddy System 测试..."
    qemuextra=
    if [ "$brkfun" ]; then
        qemuextra="-S $qemugdb"
    fi
    t0=$(get_time)
    (
        # 设置最大执行时间限制
        ulimit -t $default_timeout
        # 启动 QEMU
        exec $qemu -nographic -machine virt -bios default \
            -device loader,file=bin/ucore.img,addr=0x80200000 \
            -serial file:$qemu_out -monitor null -no-reboot $qemuextra
    ) > $out 2> $err &
    pid=$!
    sleep 3
    kill $pid > /dev/null 2>&1
}

# 检查 QEMU 输出中是否包含指定关键字
check_output() {
    if grep -q "$1" $qemu_out; then
        pass "$2"
    else
        fail "$2 (缺少输出: $1)"
    fi
}

## 编译并运行 Buddy System 测试
echo "==============================="
echo "   测试 Buddy System 物理内存管理器"
echo "==============================="

# 清理旧文件并重新编译
$make $makeopts clean > /dev/null 2>&1
$make $makeopts > /dev/null 2>&1

# 运行 QEMU
run_qemu

# 若无输出文件则提示错误
if [ ! -s $qemu_out ]; then
    echo "⚠️  未检测到内核输出，请检查 QEMU 是否正常运行"
    exit 1
fi

# 测试项（每项 5 分）
pts=5
check_output "memory management: buddy_pmm_manager" "检测伙伴系统管理器初始化"
check_output "check_alloc_page() succeeded!" "检测伙伴系统内存分配与释放"
check_output "satp virtual address:" "检测页表虚拟地址输出"
check_output "satp physical address:" "检测页表物理地址输出"

# 显示最终成绩
show_final

