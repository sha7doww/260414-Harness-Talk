#!/bin/bash
# 最小教学版 pipeline：编译 → 生成 → 校验 → 产出
set -e

PROBLEM=$1
if [ -z "$PROBLEM" ]; then
    echo "Usage: ./scripts/pipeline.sh <problem-name>"
    exit 1
fi

DIR="problems/$PROBLEM"
if [ ! -d "$DIR" ]; then
    echo "Error: $DIR does not exist"
    exit 1
fi

echo "=== Pipeline: $PROBLEM ==="

# 1. 编译
echo "[1/4] Compiling..."
g++ -std=c++17 -O2 -o "$DIR/std" "$DIR/std.cpp"
g++ -std=c++17 -O2 -o "$DIR/generator" "$DIR/generator.cpp" -I .
g++ -std=c++17 -O2 -o "$DIR/validator" "$DIR/validator.cpp" -I .

# 2. 生成数据
echo "[2/4] Generating test data..."
mkdir -p "$DIR/data"
cd "$DIR"
bash generate.sh
cd - > /dev/null

# 3. 校验输入
echo "[3/4] Validating inputs..."
for f in "$DIR/data/"*.in; do
    "$DIR/validator" < "$f"
    echo "  $(basename $f) OK"
done

# 4. 生成标准输出
echo "[4/4] Generating outputs..."
for f in "$DIR/data/"*.in; do
    out="${f%.in}.out"
    "$DIR/std" < "$f" > "$out"
    echo "  $(basename $f) -> $(basename $out)"
done

echo "=== Done: $PROBLEM ==="
