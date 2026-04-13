# 演示脚本

> Demo 1（ChatGPT 网页版）只在 talk.md 里讲，不放在本目录。这里只放 Demo 2/3/4 用得到的文件。

## 演示顺序

### Demo 2: 裸 agent（`bare/`）

1. 打开 `bare/` 目录
2. 启动 Claude Code，直接给任务（见 `bare/task.md`）
3. 观察产物：文件位置、命名、是否有 validator、能否跑通 pipeline
4. 重点展示：能做事 ≠ 能稳定做事

### Demo 3: 带 harness（`with-harness/`）

1. 切换到 `with-harness/` 目录
2. 先展示 harness 四要素：CLAUDE.md / 目录结构 / pipeline.sh / testlib.h
3. 启动 Claude Code，给**同一个任务**（继续用 `bare/task.md` 里的二分查找题）
4. 对比产物质量和稳定性

### Demo 4: 优化 harness

1. 如果 Demo 3 出现任何失败，不要口头纠正
2. 把失败模式写进 CLAUDE.md 或 pipeline.sh
3. 再跑一次，展示 harness 迭代过程
