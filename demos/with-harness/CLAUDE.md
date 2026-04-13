# CP Problem Harness (教学精简版)

## 你是谁

你是一个算法竞赛题目创建助手。你的工作是在这个 harness 中创建完整的算法题目。

## 目录结构约定

每道题目必须放在 `problems/<problem-name>/` 下，包含：

```
problems/<problem-name>/
├── statement.md          # 题面
├── std.cpp               # 标准解
├── generator.cpp         # 数据生成器（使用 testlib.h）
├── validator.cpp          # 输入校验器（使用 testlib.h）
├── generate.sh           # 数据生成脚本
└── data/                 # 生成的测试数据
    ├── 01.in / 01.out
    ├── 02.in / 02.out
    └── ...
```

## 规则

1. generator 和 validator 必须使用 testlib.h
2. 所有 .cpp 文件必须能用 `g++ -std=c++17 -O2` 编译通过
3. 先写代码，再用 `scripts/pipeline.sh <problem-name>` 验证整个流程
4. 如果 pipeline 失败，阅读错误信息并修复，不要跳过验证步骤
5. 数据至少生成 10 组，包含边界情况
6. 必须写一个 generate.sh，由它调用 generator 产出所有 .in 文件；不要绕过 generate.sh 直接在终端跑 generator

## 常见错误提醒

- 不要忘记 validator，它和 generator 同样重要
- generate.sh 必须有执行权限（chmod +x）
- data/ 下的 .in/.out 不要手写，由你写的 generate.sh + pipeline 自动产出
