# 参考资料

## Me

https://github.com/sha7doww

## My Harness Repo

- [AKO4ALL](https://github.com/TongmingLAIC/AKO4ALL)：kernel 优化
- [CP_problems](https://github.com/sha7doww/CP_problems)：算法竞赛出题
- [paper-toolkit](https://github.com/sha7doww/paper-toolkit)：论文写作 / Rebuttal
- [remote-toolkit](https://github.com/sha7doww/remote-toolkit)：远程环境访问

## 外部教学/参考 Repo

- [learn-claude-code](https://github.com/shareAI-lab/learn-claude-code) - 从 0 到 1 搭一个 nano claude code 风格的 agent harness
- [awesome-agent-harness](https://github.com/Picrew/awesome-agent-harness) - harness engineering 资源合集

## 热场素材

- 网文封面（`assets/warmup-novel.jpeg`）— "只有我无限爽用 Opus4.6 和 GPT5.4"，老米吃大鼠，番茄
- [Hanchen Li / Life](https://hanchenli.github.io/life/) — "I am a humble slave to Claude"，截图见 `assets/warmup-hanchen-life.png`

## 关键文章

- Anthropic: [Building effective agents](https://www.anthropic.com/research/building-effective-agents) — 简单可组合 > 重框架；先找最简单能工作的方案
- Anthropic: [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents) — initializer + 增量 progress + 跨 session artifacts
- Anthropic: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — context engineering 是 prompt engineering 的自然延伸
- Anthropic: [Scaling Managed Agents](https://www.anthropic.com/engineering/managed-agents) — 工程师重心从写代码转向设计环境、指定意图、搭反馈回路
- OpenAI: [Harness engineering](https://openai.com/index/harness-engineering/) — 反对一份超长 AGENTS.md；短 map + 结构化 docs as system of record
- LangChain: [The Anatomy of an Agent Harness](https://blog.langchain.com/the-anatomy-of-an-agent-harness/) — Agent = Model + Harness 的核心出处

## 评测闭环同类系统（Case B 引用）

- [autoresearch](https://github.com/karpathy/autoresearch) - Karpathy 原版：给 agent 一个 5min 训练任务，让它 propose→train→eval→keep/revert 循环跑一晚上
- [autokernel](https://github.com/RightNow-AI/autokernel) - 把 autoresearch 思路用到 GPU kernel 优化：profile → modify → eval → keep/revert，对应 PyTorch 模型自动迭代

## 自动科研系统（展望环节引用）

- [ARIS (Auto-Research-In-Sleep)](https://github.com/wanshuiyin/Auto-claude-code-research-in-sleep) - 轻量 Markdown-only 技能集，跨 agent，强调 cross-model review 和 session recovery
- [AI Scientist-v2](https://github.com/SakanaAI/AI-Scientist-v2) - 端到端自动论文生成，首篇通过 workshop 同行评审的全 AI 论文（但边界明显：开放探索成功率低、需 sandbox）
