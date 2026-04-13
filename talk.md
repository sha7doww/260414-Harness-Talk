# 从会说到会做：为 Claude Code 等 Coding Agent 构建任务特定 Harness

副标题：当只靠 prompt 不再够用——如何为 Coding Agent 搭建任务特定的工作环境
以 Claude Code 为例，但方法适用于所有 Coding Agent（Codex 等）

---

## 大纲

**核心问题**：为什么通用 Coding Agent 已经很强了，很多任务还是"不稳"？

**主线**：会说 → 会做 → 做得稳 → 按需扩展

**叙事弧**：

- 热场（-3→0 min）：用两张图引出"AI 已经颠覆我自己的工作方式"，自然把对话式 AI 和 coding agent 的分工抛出来
- 前半场（会说→会做→做得稳）：用同一个任务在三种环境里做三次，建立直觉
- 后半场（按需扩展）：用不同领域的 case 展示 harness 如何按任务需求向不同方向生长

### 一、从"会说"到"会做"：对话式 AI vs Coding Agent

- 对话式 AI（ChatGPT 网页版等）：给建议、给代码片段，你自己粘贴/运行/检查
- Coding Agent（Claude Code、Codex 等）：能读代码库、改文件、跑命令、看结果再决定下一步
- 本质区别不是模型更聪明，而是 agent 能在动态环境中行动并获得反馈
- 但能做事 ≠ 能稳定做事，通用 agent 常见失稳：目录结构随意、不知道什么算成功、做了一半接不上、同样错误反复犯

### 二、从"会做"到"做得稳"：Harness 是什么

- 定义：harness = 模型之外，让 agent 稳定工作的那套东西（Agent = Model + Harness）
- 四问：AI 看得到什么？做得了什么？怎么知道做对了？下次怎么接着做？
- prompt vs harness：prompt 管这一轮要做什么；harness 管这类任务怎么稳定做下去
- 最小 harness 四构件：
  - **结构**：目录、命名、模板
  - **动作/工具**：run / build / test 脚本
  - **裁判**：validator、checker、benchmark
  - **记忆**：progress、iterations、logs
- Harness 不是一次构建完的：构建→使用→观察失败→写回 harness→再使用（迭代循环）
- 核心原则：一旦某个错误会反复出现，就不要只改 prompt，要把它写进 harness

### 三、Harness 还能怎么长大：两种扩展方向

前面用一个最小 harness 建立了直觉。但不同任务对 harness 的需求不同，扩展方向也不同——不是线性递进，而是两种并列的加强方向，按需组合：

- **固化 workflow**：把重复流程固定下来，人仍然是主要裁判
  - paper-toolkit：论文 repo 结构 + meta.yaml + phase + pt CLI
- **固化评测闭环**：当任务有明确指标时，harness 不只让流程稳，还能让 agent 自己迭代变好
  - autoresearch、autokernel
  - AKO4ALL：setup→profile→iterate→track，ITERATIONS.md，trajectory
  - 适用前提：量化指标、目标明确、评测简单、修改范围小

  本质：你在把多少原本靠人脑盯着的工作，外包给了外部系统

### 四、边界与展望

**什么时候值得搭：**
- 值得：反复做、持续时间长、有外部反馈、失败成本高、需跨会话
- 不值得：一次性、无明确裁判、直接做更快
- 先找最简单能工作的方案，再按需要加复杂度
- 随着模型能力增强，再按需要减复杂度
- **本质：探索模型能力的边界**


**继续往前推会怎样：**

- 已经有人在做"自动科研系统"：
  - ARIS（轻量 Markdown-only 技能集，跨 agent）
  - AI Scientist-v2（端到端自动论文生成）
- 但边界很清楚：AI Scientist-v2 自己承认开放探索成功率低、必须 sandbox 运行；独立评测指出其 novelty 评估弱、代码错误率高
- 我的判断：短期内不会有系统稳定替代研究者，但科研中"可验证、可记录、可恢复"的子任务会迅速被 harness 化。对大多数人来说，更现实的路径不是追一个万能 auto-scientist，而是识别手头任务里哪些部分可以外包给结构、脚本、评测和记忆

### 金句

- 模型决定上限，harness 决定下限
- 稳定性不是来自更长的 prompt，而是来自更好的 harness
- 好的 harness 不是限制模型，而是激发模型——探索模型能力边界

---

## 时间线

节奏：每 8-12 分钟，屏幕上发生一件新的事

### 热场（-3 → 0 min）

#### -3 → 0 min | 热场：两张图 + 个人 disclose【讲】

1. 放图 1：网文封面（`assets/warmup-novel.jpeg`）
   - 一句话：穿越回古代，电力网络全崩，但脑子里还有 Opus 4.6 和 GPT 5.4，一晚上写出别人五天的内容
   - 让笑声出来

2. 放图 2：Hanchen Li 的 /life 页面截图（`assets/warmup-hanchen-life.png`，来自 https://hanchenli.github.io/life/）
   - Berkeley 做 AI Systems 的 PhD，自己主页写着 "I am a humble slave to Claude"
   - 更多笑声

3. 个人 disclose（这是热场真正的目的）
   - 这两个我都挺有共鸣的，我自己现在绝大部分工作都是让 AI 做、或者 AI 辅助做的
   - 日常聊天和简单问答 → ChatGPT
   - 编码、科研、做 PPT 这种需要在真实环境里动手的 → Claude Code / Claude 的 Cowork 功能
   - 今天想分享一些自己折腾这些工具一段时间后的经验

4. 抛出主线
   - 具体来说想讲三件事：为什么对话式 AI 不够，为什么单纯的 coding agent 也不够，以及怎么给 coding agent 搭一层任务特定的工作环境
   - 隐含一层（不说破）：列出"复杂任务我都用 Claude Code"这个动作本身，会让只用网页版 AI 的同学自己产生反思

### 前半场：一个任务，一条连续故事（0-58 min）

贯穿任务：创建一道算法题（题面 + 标程 + generator + validator + 测试数据 + pipeline）

#### 0-5 min | 开场【讲】

立住问题，宣布贯穿前半场的任务，不展开理论

#### 5-12 min | Demo 1：对话式 AI 做任务【演示】

用 ChatGPT 网页版做这个任务（可预录），暴露"会说但你得自己做"的局限

#### 12-22 min | Demo 2：裸 Claude Code 做同一个任务【演示】

在空目录里用 Claude Code 做同一个任务，暴露"会做但不稳"的问题

#### 22-30 min | 第一次抽象：引出 harness【讲】

围绕刚才裸 agent 暴露的问题来讲，不要像介绍概念一样展开：
- 刚才为什么不稳？因为三样东西没有被外化：规则（该往哪写）、裁判（怎么算对）、状态（下次怎么接）
- 这三样加起来，就叫 harness：模型之外，让 agent 稳定工作的那套东西
- 一句话对比：prompt 管这一轮；harness 管这一类
- 先记住这三件——等会儿真的把 harness 摆出来，你会发现里面还藏着第四件

#### 30-37 min | Demo 3：揭示 harness + 重跑【演示+讲】

切到 `demos/with-harness/`，不要逐个读文件，而是围绕三处关键差异来讲：
- 它现在知道该往哪写（目录结构 + CLAUDE.md）
- 它现在知道怎么跑（pipeline.sh）
- 它现在知道怎么判对错（validator + pipeline 校验）

然后在 harness 上重跑同一个任务，对比结果

#### 37-50 min | Demo 4：迭代 harness【演示】

换一个任务触发失败，不口头纠正，而是现场修 CLAUDE.md / pipeline.sh，展示 harness 从失败中长出来的过程

#### 50-55 min | 第二次抽象：四构件【讲】

从前面所有 demo 中提炼最小 harness 四构件：结构、动作、裁判、记忆

#### 55-58 min | 过渡

> 前面我演的是一个教学精简版，让大家看懂最小 harness 怎么长出来。现在带大家看看：一个成熟的 harness 长什么样，以及同样的思路能不能用到别的任务上。

### 后半场：同样的思路，不同的领域（58-90 min）

#### 58-68 min | 从教学版到真实版：CP_problems 完整 repo【演示】

核心句：**最小 harness 长成熟后会是什么样**
进 `repos/CP_problems`，对比前面教学精简版的差异，跑一个已有题目看完整流程。

过渡：
> 刚才我们解决的是一个单次工作流。那如果任务不是 20 分钟，而是跨几天、跨很多轮的论文写作呢？

#### 68-78 min | Case A：固化 workflow —— paper-toolkit【演示】

核心句：**同样的 harness 思路如何迁移到长时、跨会话的任务**
进 `repos/paper-toolkit`，展示论文 repo 结构、phase 机制、pt CLI。不讲论文自动写作，只讲 harness 迁移。

过渡：
> 光有 workflow 还不够。如果一个任务有明确外部指标——比如速度、准确率、通过率——harness 能不能不仅让它稳，还让它自己越来越好？

#### 78-90 min | Case B：固化评测闭环 —— AKO4ALL【演示】

核心句：**当任务有明确指标时，harness 如何固化反馈闭环**
进 `repos/AKO4ALL`，展示 setup→profile→iterate→track 循环、ITERATIONS.md、trajectory/。不讲 kernel 细节，只讲闭环结构。
口头带过同类系统：autoresearch、autokernel——说明这不是孤例，而是一类正在被验证的思路。

### 收束（90-118 min）

#### 90-96 min | 收束 + 边界【讲】

- 两种扩展方向总结（固化 workflow / 固化评测闭环）
- 什么时候值得搭/不值得搭
- 加复杂度 vs 减复杂度：先找最简单能工作的方案；随着模型变强，再按需要把过时的脚手架拆掉
- 上一个层次的视角：搭 harness 的本质，是探索模型能力的边界

#### 96-103 min | 展望：从 harness 到自动科研系统【讲】

把今天的主题往前推一步：如果 harness 继续长大，会变成什么？
- 一句话带 ARIS 和 AI Scientist-v2：已经有人在尝试把整个科研流程 harness 化
- 但诚实讲边界：开放探索成功率低、需要 sandbox、独立评测不乐观
- 落到自己的判断：短期内不会有万能 auto-scientist，但可验证的子任务会迅速被 harness 化
- 拉回普遍场景：不只是科研，作业、实验复现、benchmark 跑分都可以问同一个问题——哪些部分可以外包给 harness，哪些还必须由人判断

#### 103-112 min | 互动【互动】

学生提一个日常任务，现场讨论怎么搭 harness；或 Q&A

#### 112-118 min | 收尾【讲】

三句话收束：
1. 从聊天到 agent：不是更聪明，而是能在环境里行动
2. 从 agent 到 harness：不是 agent 不行，而是通用环境太松
3. 一旦错误反复出现，不要只改 prompt，要写进 harness

三句金句：

- 模型决定上限，harness 决定下限
- 稳定性不是来自更长的 prompt，而是来自更好的 harness
- 好的 harness 不是限制模型，而是激发模型——探索模型能力边界
