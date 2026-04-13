Q:

我的老师让我去参加一个技术沙龙并进行技术讲座。我们的对话如下： --- 下周二下午你能来复旦办个讲座吗？ 需要办个技术沙龙，我在想你要么做个讲座讲讲如何搭一个基于Claude code的智能体来做代码优化 杨老师，我之前没做过类似的，这是个什么样的形式，还有代码优化指的是哪方面 就是给本科生上一节课的形式，估计两个小时 好的杨老师，那就是大致讲：针对不同的任务，怎么为 Claude Code 等 Coding Agent 搭一个 Harness，来更好、更高效地去做这些任务吗？以及任务是泛指所有代码任务，还是特定于“优化”类的代码 [嘿哈] 泛指，但是可以搞一些特定的例子，因为是技术沙龙 主要还是动手演示为主的 好的杨老师，那我可以的。 --- 我的大致想法是侧重 “Harness”的构建，因为 Claude Code 本身 = Model + Harness。不过 Claude Code 自带的 Harness 是针对通用任务，虽然也能解决很对任务，但是如果没有外包一层针对任务特定的 Harness，那很多时候用起来不够 “稳定”、“效率也不够高”。当然也不一定每个任务都要去特定优化，简单来说，如果一个任务是长时间任务或者会多次反复进行（比如论文写作、实验构建和运行），那就可以考虑为它搭一个 harness。你觉得呢？ 所以我的大致内容就是 Harness 的构建，而不会讲太多 Claude Code 本身的使用，比如 git worktree 并行、skill、mcp、multi agent 之类的，因为他们是 Claude Code 本身的知识，网上也能找到很多相关的分享。这些知识可以被包含进我们搭建的 Harness 中，即我们的 Harness 可以利用上 CC 自带的这些功能来达成效果更好的 harness，但是不是必需的。 先声明该技术内容适用于所有 Coding Agent（不一定需要 Claude Code），但因为我 CC 用得最多，偶尔使用 Codex，所以后面的演示以 Claude Code 我想大致分这几个部分： 

1. Claude Code 简单介绍和使用，不讲进阶知识，只讲最基础的使用，然后稍微对比和传统方式（比如网页版 ChatGPT 的不同）
2. harness 是什么，它的定位（但要在这里讲吗，我怕干讲会很抽象）。  
3. 简单的 harness：如何把一个长时/多次任务变得简单、高效、稳定。 这个部分虽然基础，但是可以花最多时间讲，因为我们面向的是本科生，所以应该讲最实用的。比如论文写作 harness，作业修改 harness 之类的。怎么搭建一个 harness ？让 CC 帮你搭建。所以实际上有 ”两个 CC“，一个用于 harness 构建，和你一起优化给 “另一个 CC” 工作的 harness；另一个 CC 是在构建的 harness 上针对特定任务的实例工作。共同迭代：harness 不可能一开始就搭的很完美，需要另一个 CC 在其上实际工作、记录反馈、才能根据运行过程中的表现去进一步优化 harness 本身。（但是具体怎么讲？是讲整个 harness 的构建过程？这样会不会太耗时了；但直接拉一个 harness 下来讲使用，会不会又不能讲到 harness 的构建？）
4. 进一层：跑实验/做优化的 harness，类似 autoresearch、autokernel、AKO 之类的，参考这个项目中的 Agentic All Optimization分析对话。
5. 再进一层，可以点到现在出现了很多自动论文/实验的系统，比如 AIS，ARIS 之类的，但他们真的效果可以很好吗？同样参考 Agentic All Optimization分析对话 和 LLM Kernel Optimization 基建建议这两个对话。所以更进一层的 harness 是完整针对任务特定的 infra、基建，我觉得这样才能真正实现从 idea 到论文的完整写作（但也很难，因为论文是没有固定指标的，所以很难自动迭代，必须人的介入）。



下面是我之前搭建的一些 harness：

https://github.com/TongmingLAIC/AKO4ALL

https://github.com/sha7doww/CP_problems

https://github.com/sha7doww/paper-toolkit

https://github.com/sha7doww/remote-toolkit

当然你不用局限于我自己之前搭建的 harness，可以看看有没有适合教学、分享讲座的 harness。



A:

我觉得你的方向是对的，而且可以再 sharpen 成一句更好讲的话：**你这场讲座不是在教 Claude Code 的功能，而是在讲怎么给通用 Coding Agent 搭一层任务专用 harness，让它从“偶尔灵”变成“稳定可复用”。** Anthropic 把 Claude Code 定义为能读代码库、改文件、跑命令的 agentic coding tool；OpenAI 在 Codex 的架构文里也把 harness 视为编排用户、模型和工具交互的核心逻辑；LangChain 最近直接把这件事概括成 “Agent = Model + Harness”。所以你把重点放在 harness，而不是 worktree、skill、MCP 这些零散 feature，我觉得完全正确。 



你对“什么任务值得搭 harness”的直觉也很准。Anthropic 在 long-running agents 一文里明确说，通用 harness 的 compaction 还不够支撑跨多个 context window 的长时任务，所以他们用了 initializer、进度文件和增量式交接；他们另一篇 context engineering 文章又强调 “just-in-time” 上下文：不要一次把所有资料塞进模型，而是给它文件、索引、脚本和命名结构，让它按需探索。翻成讲座里的话就是：**长时间、会反复做、失败代价高、需要恢复现场的任务，最值得搭 harness。** 



我会改你现在大纲的三件事。



第一，**不要单开一节抽象讲 “harness 是什么”**。先让学生看到“同一个 agent 为什么会忽好忽坏”，再给定义。甚至第一遍可以先不用 harness 这个词，先说“任务壳”或者“工作系统”。等 demo 跑完，再抛一句：**harness 就是模型之外，所有给它状态、工具、反馈和约束的东西。** 这样学生会立刻懂。 



第二，**把你的 3/4/5 收成“三层 harness”**，会比“简单 harness / 跑实验 harness / 更大系统”顺很多。

1）**环境层**：让 agent “够得到工作现场”。你的 remote-toolkit 用 SSHFS 把远程目录挂到本地，让 Claude Code 直接读写远程文件，并用 SSH + tmux 保住长时命令，这特别适合讲“没有这层壳，agent 连门都进不去”。 

2）**流程层**：让 agent “知道什么叫好输出”。CP_problems 把出题变成标准目录 + testlib + generator/validator + pipeline；paper-toolkit 把论文工作流收束成固定 repo 结构、phase、commands、meta.yaml 和 CLAUDE.md。这类例子最能说明：很多稳定性不是来自更强模型，而是来自更清楚的工作流。 

3）**评测层**：让 agent “能自己迭代变好”。autoresearch 里人主要写 program.md，agent 主要改 train.py；AutoKernel 把这个思路扩成 profile → extract → bench → verify；AKO4ALL 则把 kernel / reference / bench / context / hints 标准化，并把每轮 profile、benchmark 和 trajectory 固化下来。你后面讲 AKO / optimization，就顺着这一层讲最自然。 



第三，**“两个 CC” 这个说法建议换成“双环结构”**。内环是工作 agent，在既定 harness 里做任务；外环是 harness builder，负责改 CLAUDE.md、脚本、评测和目录结构。Anthropic 那篇“给 agent 写工具”的文章，本质也是这个思路：先做 prototype，再跑 eval，再让 agent 帮你把工具迭代好。你这样讲，会比“开两个 Claude Code 窗口”更像一个方法论。 



按这个逻辑，2 小时我会这样排。

1）前 10 分钟：只讲最小必要的 Claude Code。它能读代码库、改文件、跑命令，这一点讲清楚就够了；quickstart 级别的内容官方文档已经很完整，你这里不要讲成产品培训。 

2）接着 15 分钟：做一个“裸 agent 失败”的小演示，让学生先感受到不稳定。

3）然后 30-35 分钟：现场补一个**最小 harness**，但不要从 0 到 1 live coding 全搭。最好是你提前准备一个 v0 repo，只放 CLAUDE.md、TASK.md、scripts/run.sh，故意缺两样关键东西：eval.sh 和 progress.md。现场让 agent 跑一次、失败一次、补壳、再跑一次。这样既讲到了构建，也讲到了使用。

4）再用 25 分钟：串你的三个 case——remote-toolkit 讲环境层，CP_problems 或 paper-toolkit 讲流程层，AKO4ALL 讲评测层。

5）最后 10-15 分钟：讲边界和未来。AI Scientist-v2 的 README 一方面写它生成了一个被 workshop 接收的全 AI 论文，另一方面也明确承认：在有强模板时，v2 不一定比 v1 更好，而且运行时要放在受控 sandbox，因为它会执行模型写的代码。ARIS 则反过来强调自己是 “methodology, not a platform”，核心只是 Markdown-only skills。这个收尾正好落到你的观点：**真正有价值的不是一个万能 agent，而是按任务把 harness 和 infra 做到合适的程度。** 



主 demo 我反而**不建议**用论文写作。论文写作当然是长时任务，但现场最容易滑到“内容好不好”这种软判断上。**本科生场景下我更建议把 CP_problems 当主 demo**：因为它的好坏更可验证，statement / std / generator / validator / data 一眼能看出 harness 到底帮了什么；remote-toolkit 更适合做第二个小 demo，说明环境壳的价值；paper-toolkit 放到研究场景补充即可。 



除了你自己的 repo，外部材料里我会选三个做补充：learn-claude-code 很适合作为“从 0 到 1 理解 harness”的课后材料，因为它就是按 loop / tools / planning / context / permissions / hooks / memory 这些骨架来教的；awesome-agent-harness 适合做延伸阅读；revfactory/harness 可以拿来当一页前沿补充，说明“让 agent 帮你生成 harness”也已经有人在做，但它不适合当这场课的主 demo。 



一句话收束就是：**模型决定上限，harness 决定下限；对长时、重复、可验证的任务，harness 决定你能不能把一次偶然成功，变成稳定交付。**



下一条我可以直接把这个结构写成 **12–15 页 slide 提纲 + 每一段该怎么讲 + 一个主 demo 脚本**。





Q:

我有一些问题：

收成“三层 harness” 本科生真的能搞懂吗？虽然这样更加本质/深入，但只是让 Coding Agent 从“偶尔灵”变成“稳定可复用”是否需要这么复杂？

关键是怎么串联起来不同的内容，因为有好几条线：

工具：从传统的网页版 AI 比如 ChatGPT 到 Claude Code 这种 cli coding agent 再到我们自己构建任务特定的 harness，它们各有什么优势，为什么前一个不够需要后一个？

harness 本身：从简单到复杂

harness：从构建到使用再到优化

这三条线都简单涉及到并讲清楚尤其是有例子能够让同学们很好懂，做到这些就很困难了？



比如我说的 1 -> 2 是否可以讲 cc 这种 code agent 和 gpt 这种model 的区别是什么？我觉得本质就是 agent 能够在动态的环境中与其交互并获得反馈。

那么就自然引申到 2. 一个合适的动态环境是什么样的。



所以你需要思考：就是你上面的每一点，和讲座的主题 harness 的内在联系是什么。这几条线怎么串起来，然后之间又是怎样的递进/并列关系的，感觉像这种讲座，比较关键的就是不能让人听起来觉得很没有逻辑。3、4、5这几种不同的 harness 有什么区别？就比如 3. 简单的harness，可以对比 prompt engnieering 和 harness 的区别，根据这个就可以进一步详细讲 搭建一个 harness 需要考虑什么，从而引出具体的论文harness的例子。



等等。你需要进一步思考和分析。





A:

你这次追问把真正的问题抓到了：**不是内容够不够，而是主线能不能只剩一条。** 现在我更确定，这场讲座不能把三条线平行摆开讲；它必须是一条楼梯：**从会说，到会做，到做得稳，再到越做越好。** 另外还有一个现实细节：今天的 ChatGPT 产品本身已经有 Projects、data analysis、web search，甚至 ChatGPT agent；而 Claude Code、Codex CLI 这类产品则更明确地围绕代码仓库、文件编辑和命令执行来设计。所以课堂上最好不要把“ChatGPT 网页版”讲成“纯聊天模型”，而是把它表述成**对话式使用心智**，再和**coding agent 的工作流心智**做对比。 





## **1. 本科生能不能懂“三层 harness”？**





**能懂，但不要直接这么讲。**

“环境层 / 流程层 / 评测层”这种说法适合你自己备课，不适合直接端给本科生。面向学生，我会把它压成四个非常朴素的问题：



**AI 看得到什么？做得了什么？怎么知道做对了？下次怎么接着做？**



这四问已经把 harness 最核心的东西都包住了。Anthropic 一直强调，成功的 agent 系统往往来自**简单、可组合**的设计，而且应当先做“最简单、能工作的那件事”。所以“为了让 Coding Agent 从偶尔灵变成稳定可复用”并不意味着你要讲复杂理论；你只是在补齐最小工作系统：context、actions、feedback、resume。模型本身做不到持久状态、执行代码、访问外部环境或把工作现场搭起来，这些才是 harness 的工作。不是每个任务都值得特化 harness；真正回报高的，通常是重复、长时、而且有外部反馈的任务。 





## **2. 你现在的三条线，其实不是并列关系**





我会把它们重新归位成：



**工具线**，回答“为什么前一个不够，需要后一个”；

**harness 简繁线**，回答“我们到底把什么东西逐步外包给系统了”；

**构建-使用-优化线**，回答“这套系统是怎么长出来的”。



所以它们不应该并列出现，而应该分别放在：



**开头的动机**、**中间的主体**、**demo 的叙事动作**。



也就是说，你不是在同时讲三个框架；你是在讲**同一个系统如何一步步被工程化**。Anthropic 和 LangChain 对 harness 的定义都指向同一件事：模型之外的状态、工具、反馈、约束和编排逻辑，让一个模型变成能工作的 agent；而 OpenAI 在讲 harness engineering 时，也把重心放在环境设计、反馈回路和可维护的系统骨架上。 





## **3. 你说的“agent 能在动态环境中交互并获得反馈”，方向是对的，但还可以再精确一点**





我会把 1 → 2 这样讲：



**如果 AI 主要是在对话里产出文本，它更接近“会说”；**

**如果 AI 能读文件、改代码、跑命令、看结果再决定下一步，它就进入了“会做”的阶段；**

**如果这套做事方式被固定成一个可复用、可检查、可恢复的工作环境，它才进入 harness。**



Anthropic 的 tool-use 文档里，工具调用本质上就是：模型提出 action，外部环境执行，再把结果反馈回来；Claude Code 官方也明确把自己定义成能读代码库、改文件、跑命令的 agentic coding tool。LangChain 对此的概括也很直接：**Agent = Model + Harness。** 



所以，一个“合适的动态环境”至少要满足四点：



**可观察**：关键状态不是藏在你脑子里，而是放在 repo、目录结构、命名、文档里；

**可行动**：agent 有稳定的脚本和命令可以改变环境；

**可裁判**：环境能给出外部反馈，而不是让模型“自我感觉良好”；

**可恢复**：跨会话能留下 clean state、progress、notes、logs。



Anthropic 讲 long-running agents 时，强调 initializer、incremental progress 和 clean state；讲 context engineering 时，又强调上下文不该是一大坨 prompt，而应该是有组织的文件、引用、工具和运行时检索。OpenAI 那篇 harness engineering 文章也说得很像：问题常常不是模型不行，而是环境 underspecified，于是他们把 repo 知识变成 system of record，而不是把所有规则塞进一份超长 AGENTS.md。 





## **4. 所以 3 这一节，很适合拿“prompt engineering 和 harness 的区别”来立住**





这个切法我觉得非常好。



Anthropic 明确把 **context engineering** 看作 **prompt engineering** 的自然延伸：prompt 关注“这一次怎么写指令”，而 context/harness 关注“多轮、长时任务里，哪些信息、工具、历史和外部数据持续进入模型”。你在课堂里完全可以把它翻成一句更口语的话：



**prompt 是告诉模型该怎么说，harness 是安排模型在什么世界里工作。**



再进一步，你甚至可以给学生一个很容易记住的对比：



**prompt 写在消息里；harness 写进仓库里。**



OpenAI 那篇文章里一个很有启发的点，也是这个方向：他们发现一份超大的 AGENTS.md 很快会变成上下文负担，于是改成“短 AGENTS.md + 结构化 docs 目录 + 明确的 system of record”。这其实就是在告诉学生：**稳定性不是来自更长的提示词，而是来自更好的工作环境。** 





## **5. 3、4、5 不是三种神秘 harness，而是同一件事的三个加强版**





我会这样定义它们。



**3. 简单 harness：把重复 workflow 固化下来。**

重点不是“自动化很强”，而是“按套路做”。CP_problems 已经把题目目录、CLAUDE.md、pipeline.sh、数据生成、验证和测试流程标准化了；paper-toolkit 则把论文仓库、meta.yaml、phase、compile/review 命令和 Claude workspace 固化下来。这一层里，人还是主要裁判，agent 只是沿着更清楚的轨道工作。 



**4. 优化 harness：把“好坏判断”也外包给系统。**

这时重点变成“自己知道哪里没做好，然后继续试”。AKO4ALL 的关键不只是“会改 kernel”，而是它把 bench、profile、HINTS.md、ITERATIONS.md 和 trajectory 都外显出来，形成 setup → profile → iterate → track 的循环。Anthropic 和 LangChain 在 2026 年都在强调：evals 和 traces 是 harness 改进的学习信号。到这一步，harness 就不只是工作壳，而开始变成一个 optimization loop。 



**5. infra / 基建 harness：连工作现场本身都要被工程化。**

当问题不再是“怎么做”，而是“agent 连现场都进不去”时，你就得把环境本身设计出来。remote-toolkit 的价值就在这里：远程目录通过 SSHFS 挂到本地，Claude Code 可以直接读写；长时命令通过 SSH + tmux 保持运行。OpenAI 那篇 harness engineering 文章也有同样的味道：随着 testing、validation、review、feedback handling、recovery 被逐步编码进系统，agent 的 autonomy 才会上去。这里不是多了一个新概念，而是 harness 开始覆盖环境本身。 



所以更本质地说，3/4/5 的差别不是“类型学”，而是**你把多少工作从人脑和临场提示词里，外包给了外部系统**。





## **6. 真正让讲座逻辑顺起来的关键：不要把“构建 → 使用 → 优化”单开一章**





这条线最好的处理方式，不是讲理论，而是让它**长在 demo 里**。



也就是：



先让 bare agent 失败一次；

再补最小 harness；

再用它跑一遍；

最后根据日志、validator、benchmark 或失败轨迹去改 harness。



这样，“构建 → 使用 → 优化”就不是一套抽象方法，而是学生现场看见的一次因果链。Anthropic 的 long-running harness、OpenAI 的 harness engineering，以及 LangChain 的 better-harness，本质上都在做同一件事：**从失败里抽信号，再把信号写回 harness。** 





## **7. 具体到教学，我会怎么串**





我建议你只用 **一个主例子** 贯穿前 60–70 分钟，其他例子都只当“扩展视野”。



主例子我还是更倾向 **CP_problems**。原因很简单：它特别适合本科生理解“为什么要从模型走到 agent，再走到 harness”。



你可以让大家看到：



对话式 AI 最多给你题面、标准解、生成器草稿；

Claude Code 已经能创建文件、补代码、跑命令；

但只有进了 CP_problems 这种 harness，结果才会稳定落在标准目录里，并且自动经历编译、生成、验证、产出数据这条 pipeline。



这条链一眼就能说明：**前一个为什么不够，后一个到底多做了什么。** paper-toolkit 适合拿来说明同一原则可以迁移到论文写作；AKO4ALL 则适合收尾，说明当 objective 可测时，harness 会从“稳定工作”进化到“自动优化”。 





## **8. 我会把你的讲座重写成这条逻辑链**





1. **为什么只是对话还不够？**

   从“会说”到“会做”。

2. **为什么有了 coding agent 还不够？**

   通用 agent 会做，但不稳。

3. **最小 harness 长什么样？**

   看得见、做得动、知道好坏、接得上。

4. **harness 是怎么长出来的？**

   从一次失败里抽出规则、脚本、评测和记录。

5. **它能长到多强？**

   从 workflow harness，到 optimization harness，再到 infra harness。





这样，**工具线**放在 1–2，**harness 本身**放在 3 和 5，**构建-使用-优化**则不单独讲理论，而是直接长在 4 的 demo 里。整个讲座听起来就会像一个递进的故事，而不是三套框架并排摆在台上。 



下一条我可以直接把这套逻辑收成一版 **2 小时讲座大纲**，包括每 10–15 分钟讲什么、每一段怎么过渡、以及主 demo 该怎么设计。





Q:

好的，请给出 2 小时大纲





A:

下面这版我按**一条主线**来排：**从会说，到会做，到做得稳，再到越做越好。**

Claude Code 官方把自己定义成能读代码库、改文件、跑命令的 *agentic coding tool*；OpenAI 也把 Codex 表述成 *coding agent*。Anthropic 则把 *context engineering* 看成 *prompt engineering* 的自然延伸，并在 long-running agents 一文里强调：跨多轮、长时间任务要靠环境初始化、外部 artifacts 和连续交接来维持进展。也就是说，你这场课很适合从“工具差异”自然过渡到“为什么需要 harness”。 





## **讲座标题**





**从会说到会做：为 Claude Code 等 Coding Agent 构建任务特定 Harness**



副标题可以是：



**为什么 prompt 不够，什么时候该搭 harness，以及如何把 agent 变成稳定可复用的工作系统**



------





## **120 分钟总安排**







### **0–10 分钟｜开场：今天到底讲什么？**





这一段只做一件事：**把整场课的问题立住**。不要一上来讲 Claude Code 命令，也不要先定义 harness。先说：



> 今天我不是来讲“怎么更熟练地用 Claude Code”，

> 我是来讲：**为什么通用 coding agent 还不够，以及怎么给它搭一个任务特定的工作系统。**



你要讲的内容：



- 给出整场课唯一主线：**网页版 AI 更像“会说”，coding agent 更像“会做”，harness 则是让它“做得稳”。**

- 先扔出一个问题让学生进入状态：

  “如果我让 AI 帮我出一道算法题、生成测试数据、检查正确性、后续继续改进，这件事只靠聊天窗口够吗？”

- 明确范围：

  **不讲** worktree 并行、MCP、multi-agent、skills 这些进阶 feature；今天只讲它们背后的共同问题——**如何给 agent 搭环境**。





过渡句：



> 从网页版到 coding agent，真正变化不是它更会说了，而是它开始能在环境里行动。



------





### **10–25 分钟｜第一部分：为什么聊天不够，需要 coding agent？**





Claude Code 官方的最小定义其实已经够你这里用了：它能读代码库、编辑文件、运行命令。OpenAI 现在对 Codex 的描述也类似，重点都是“完成真实工程工作”，而不是只输出一段文本。 



你要讲的内容：



- 用一个统一任务来比较三种使用方式，例如：

  **“帮我创建一道竞赛题：题面、标准解、数据生成器、validator、并生成样例数据。”**

- 对比“聊天式 AI”和“coding agent”的本质差异：

  

  - 聊天式：给你建议、代码片段、思路，你自己粘贴、自己运行、自己检查。
  - coding agent：它能自己看目录、创建文件、运行脚本、看报错、继续修改。

  

- 给出一句最核心的话：

  **agent 的本质不是更长的 prompt，而是“能在动态环境中行动并获得反馈”。**





建议展示：



- 一张对比 slide 就够：

  **ChatGPT / 网页对话** → 输出文本

  **Claude Code / Codex** → 读文件 + 改文件 + 跑命令 + 看结果





过渡句：



> 但能做事，还不等于能稳定做事。通用 agent 经常是“偶尔灵”，下一步我们要问：为什么？



------





### **25–40 分钟｜第二部分：为什么有了 coding agent 还不够，需要 harness？**





这一段是整场课的概念核心。Anthropic 把 *context engineering* 视为 *prompt engineering* 的延伸：问题不再只是“这次怎么写 prompt”，而是“要给模型什么上下文、工具、历史和状态，才能持续地产生我们想要的行为”。他们在 long-running agents 的文章里还强调，长时任务会跨多个 context window，因此需要 initializer、增量进展和可交接的 artifacts。OpenAI 的 Codex harness 文章则进一步说明，harness 不只是 agent loop，还包括 thread persistence、tool execution、config/auth 等外围能力；另一篇文章还明确反对“一份超长 AGENTS.md 包打天下”，而更推荐“短 AGENTS.md + 结构化 docs 作为 system of record”。 



你要讲的内容：



- 先别急着说“harness 的定义”，先讲**通用 agent 为什么不稳**：

  

  - 它不知道你希望产物落在什么目录结构里。
  - 它不知道什么算成功，什么算失败。
  - 它做了一半，下次回来可能接不上。
  - 同样的错误会一遍遍犯，而你只能一遍遍提醒。

  

- 然后再给出一个**非常本科生友好的定义**：

  **harness 就是模型之外，那套让 agent 能稳定工作的环境。**

- 用四个问题解释 harness，而不是讲抽象术语：

  

  1. **AI 看得到什么？**
  2. **AI 做得了什么？**
  3. **AI 怎么知道做对了？**
  4. **AI 下次怎么接着做？**

  

- 再用一句很好记的话收住：

  

  - **prompt 是告诉模型这次该怎么说；**
  - **harness 是安排模型在什么世界里工作。**

  





建议展示：



- 一页“prompt vs harness”：

  

  - prompt：这次对话里的指令
  - harness：目录、脚本、评测、文档、状态、日志、约束

  





过渡句：



> 既然 harness 不是一个抽象词，那我们就别空谈定义，直接看一个最小可用 harness 长什么样。



------





### **40–75 分钟｜第三部分：主 demo——一个最小 harness 怎么长出来？**





这一段我建议你用 **CP_problems** 做主 demo，而不是论文写作。原因很简单：它更容易让本科生看出“好坏差异”，因为它有明确产物和流水线。这个 repo 已经把 CLAUDE.md、testlib.h、scripts/pipeline.sh 和标准问题目录放好了；README 里也明确说，Claude Code 可以自动创建题面、标准解、数据生成器、validator，并通过 pipeline 生成和校验数据。流水线会编译组件、运行 generate.sh、校验输入文件、再生成标准输出。 



这一段建议拆成三小步。





#### **40–50 分钟｜先让“裸 agent”做一次**



你要讲的内容：



- 给一个简单任务：

  “请创建一道关于二分查找的算法题，故事背景是奶龙和小七，要求包含题面、标准解、generator、validator 和测试数据。”

- 让学生先想：如果没有 harness，agent 可能会出什么问题？

- 你可以展示一个“预录失败”或半失败结果：

  

  - 文件名不统一
  - 缺 validator
  - 数据结构不规范
  - 样例能跑，但 pipeline 不通
  - 下次继续改时，agent 不知道哪些是约束，哪些只是随手建议

  





你要强调的话：



> 问题不是它不会写代码，

> 问题是它不知道**这项工作在你的环境里究竟该怎么完成**。





#### **50–63 分钟｜把最小 harness 揭示出来**



你要讲的内容：



- 展示 harness 里最重要的几样东西：

  

  - CLAUDE.md：任务规则和工作约定
  - 目录结构：题目应该长什么样
  - pipeline.sh：一键编译、生成、校验
  - testlib.h：公共依赖

  

- 你可以对学生说：

  > 我们不是在“给 AI 更多提示词”，

  > 我们是在“把工作现场搭好”。





这里要强调一个特别重要的点：



- **harness 不是一次性写完的。**
- 它往往是 agent 先做一遍，你观察失败，再把失败固化成脚本、规则或检查。







#### **63–75 分钟｜再跑一次，并现场展示“优化 harness，而不是重复催它”**



你要讲的内容：



- 重新让 agent 在 harness 上做同类任务。

- 只要出现失败，就不要说“再试一次”；而是说：

  

  - 这个错误是否会重复？

  - 如果会，那它应该被写进哪儿？

    

    - CLAUDE.md
    - 模板文件
    - pipeline
    - checker / validator

    

  

- 给出这一段最重要的一句话：

  > **一旦某个失误会重复出现，它就不该只靠口头提醒解决，而应该写进 harness。**





过渡句：



> 刚才这个 demo 其实已经把“构建 → 使用 → 优化”完整走了一遍。下一段我们把它抽象成一个通用方法。



------





### **75–90 分钟｜第四部分：把 demo 提炼成一个通用方法**





Anthropic 在 effective agents 一文里强调，真正成功的 agent 系统往往靠的是**简单、可组合**的模式，而不是很重的框架。OpenAI 的经验也类似：不要把所有规则都塞进一份巨大的 AGENTS.md，而应让短文档充当“地图”，更详细的知识落在结构化 repo 里。 



你要讲的内容：



- 直接把刚才的 demo 总结成 4 个构件：

  

  1. **结构**：目录、命名、模板
  2. **动作**：run / build / test / compile 脚本
  3. **裁判**：eval、validator、benchmark、checker
  4. **记忆**：progress、notes、iterations、logs

  

- 再把“构建 → 使用 → 优化”说成一个循环：

  

  - 先搭一个最小版本
  - 让 agent 在上面真实工作
  - 把失败模式写回 harness

  

- 这里你可以给一个很实用的结论：

  > **最小 harness 往往不是一个“更大的 prompt”，**

  > **而是一套 repo 里的文件和脚本。**





建议展示：



- 一页“最小 harness 模板”：

  

  - CLAUDE.md
  - TASK.md
  - scripts/run.sh
  - scripts/eval.sh
  - progress.md

  





过渡句：



> 到这里，我们已经解释了简单 harness。那它能不能继续长大？可以，但不是突然跳到另一类东西，而是同一件事逐步外包更多工作。



------





### **90–105 分钟｜第五部分：从简单 harness 到更强 harness**





这一段不要讲成“三种平行分类”，而要讲成**同一件事的三个加强版**：你逐步把 workflow、评测、环境外包给系统。





#### **90–95 分钟｜workflow harness：paper-toolkit**



paper-toolkit 很适合做“迁移案例”。它把论文工作放进标准 git 仓库布局里，pt CLI 会通过 meta.yaml 自动找到 paper root；它还支持 compile、review fetch、phase rebuttal 等操作，并在 phase 变化时更新 CLAUDE.md 和 meta.yaml。这很适合说明：**论文这类长时任务，也能先从 workflow harness 开始。** 



你要讲的内容：



- 同样的原则可以迁移到论文写作：

  

  - 目录结构固定
  - phase 固定
  - 常用命令固定
  - review / rebuttal 的资料沉淀下来

  

- 但它仍然主要是 **workflow harness**，不是全自动科研。







#### **95–100 分钟｜optimization harness：AKO4ALL**



AKO4ALL 的 README 很适合你讲“当任务有明确 objective 时，harness 会从稳定执行升级到自动优化”。它要求的核心输入只是 kernel，其他如 reference、benchmark、context、hints 都是可选；运行后会经历 setup、profile、iterate、track，每轮都会修改 kernel、benchmark、把结果写进 ITERATIONS.md，并保存 trajectory。 



你要讲的内容：



- 这里和前面最大的不同，不是 agent 更强了，而是：

  

  - **有明确外部指标**
  - **有 profile / benchmark 反馈**
  - **每轮尝试被系统记录下来**

  

- 这就是你说的“做优化/跑实验”的 harness。







#### **100–105 分钟｜infra harness：remote-toolkit**



remote-toolkit 适合说明另外一件事：有时不是 workflow 不够，而是 **agent 根本够不到工作现场**。它通过 SSHFS 把远程目录挂到本地，让 Claude Code 能直接 Read/Edit/Write 远程文件；命令通过 SSH + tmux 执行，从而让长时任务不因为本地会话中断而丢掉。 



你要讲的内容：



- 这里的 harness 重点不是 prompt，也不是 pipeline，而是**环境可达性**。

- 用一句话总结这三个例子：

  > **简单 harness 固化 workflow；**

  > **优化 harness 固化评测闭环；**

  > **infra harness 固化工作现场。**





过渡句：



> 但并不是每个任务都值得走到这么深。最后我们把边界讲清楚。



------





### **105–115 分钟｜第六部分：什么时候值得搭 harness，什么时候不值得？**





Anthropic 关于 long-running agents 的文章本身就在说：这类工作之所以需要额外 harness，是因为任务跨多个 context window、持续时间长、需要交接和外部 artifacts。与此同时，他们关于 effective agents 的经验又说明，别一上来就上重型框架，**简单、可组合**往往更有效。 



你要讲的内容：



- **值得搭 harness** 的任务：

  

  - 会反复做
  - 持续时间长
  - 有外部反馈
  - 失败成本高
  - 需要跨会话续上

  

- **不太值得搭** 的任务：

  

  - 一次性、小任务
  - 没有明确外部裁判
  - 你自己手做都比搭壳快

  

- 对论文/科研类任务再补一句边界：

  

  - workflow 可以大量 harness 化
  - 但“论文是否有贡献”这类没有固定指标的问题，仍然离不开人的介入

  





建议展示：



- 一页“是否值得搭 harness”的判断清单





过渡句：



> 所以今天真正想让大家记住的，不是某个工具名，而是一种判断方式。



------





### **115–120 分钟｜结尾：把全场收成 3 句话**





你最后就收成这三句：



1. **从聊天窗口到 coding agent，不是模型突然变聪明，而是它开始能在环境里行动。**
2. **从 coding agent 到 harness，不是 agent 不行，而是通用环境太松，所以它不够稳。**
3. **一旦某种失败会重复出现，就不要只改 prompt，要把它写进 harness。**





最后一句可以作为全场金句：



> **模型决定上限，harness 决定下限。**



------





## **这套大纲里，三条线分别放在哪里**





这样安排以后，你之前担心的三条线就不会打架了：



- **工具线**：放在 0–25 分钟

  回答“为什么前一个不够，需要后一个”

- **harness 本身从简单到复杂**：放在 25–40 和 90–105 分钟

  回答“harness 到底是什么，以及能长到什么程度”

- **构建 → 使用 → 优化**：放在 40–90 分钟的主 demo 里

  不单独讲理论，而是让学生在例子里看见它





这样整场课就不是三套框架并列，而是一条很顺的楼梯：

**聊天 → agent → harness → workflow harness → optimization harness / infra harness。**





## **一个很重要的取舍**





我建议你**只用一个主 demo 贯穿全场**，其他都点到为止。

主 demo 用 **CP_problems**，因为它最可判别；

paper-toolkit 用来说明这个思路能迁移到论文场景；

AKO4ALL 和 remote-toolkit 用来说明 harness 会继续升级，但不要现场深讲实现细节。





## **明确不讲的内容**





为了逻辑干净，建议你把下面这些都放 appendix，除非被问到：



- git worktree 并行
- MCP
- skills
- multi-agent
- Claude Code / Codex 的各种 feature 清单





因为这场课的主题不是“产品技巧大全”，而是：

**如何把通用 agent 变成任务特定的稳定系统。**



我可以下一条直接把这份 2 小时大纲继续展开成 **12–14 页 slides 提纲**。





Q:

好的，帮我生成 slides 提纲





A:

下面这版我直接按 **14 页主 deck** 来写，适合你这场 **2 小时技术沙龙**：



- **主内容**：约 105 分钟
- **Q&A**：约 10 分钟
- **机动**：约 5 分钟





我刻意**不把“三层 harness”放进主 deck 的标题里**，因为对本科生来说，台上最好只保留一条更容易跟住的主线：



> **从会说，到会做，到做得稳，再到越做越好。**



------





# **14 页 slides 提纲**







## **1. 封面**





**标题**

**从会说到会做：为 Claude Code 等 Coding Agent 构建任务特定 Harness**



**副标题**

为什么 prompt 不够，什么时候该搭 harness，以及如何把 agent 变成稳定可复用的工作系统



**页面上放什么**



- 你的名字 / 单位

- 一句钩子：

  **模型决定上限，harness 决定下限**

- 小字说明：

  **以 Claude Code 为例，但方法适用于所有 Coding Agent**





**你讲什么**



- 今天不是 Claude Code 功能培训课。

- 今天只回答一个问题：

  **为什么通用 coding agent 已经很强了，但很多任务还是“不稳”？**





------





## **2. 今天这场讲座只回答一个问题**





**标题**

**为什么通用 Coding Agent 还不够？**



**页面上放什么**



- 不讲：worktree、MCP、multi-agent、skills 大全

- 只讲：**如何给 agent 搭一个更适合任务的工作环境**

- 全场主线：

  

  1. 会说
  2. 会做
  3. 做得稳
  4. 越做越好

  





**你讲什么**



- 你要把三条线收成一条楼梯，而不是三套框架并列。

- 后面所有内容都围绕同一个问题展开：

  **“为什么前一个不够，需要后一个？”**





**过渡句**



> 先从最直观的地方开始：聊天窗口和 coding agent，到底差在哪？



------





## **3. 从“会说”到“会做”**





**标题**

**同一个任务：对话式 AI、Coding Agent、Harness 有什么区别？**



**页面上放什么**

建议做成三列对比：



**左：对话式 AI**



- 给思路
- 给代码片段
- 给解释
- 你自己复制、运行、检查





**中：Coding Agent**



- 读代码库
- 改文件
- 跑命令
- 看结果再继续改





**右：任务特定 Harness**



- 规定目录结构
- 给标准脚本
- 提供成功判定
- 支持续做和迭代





**你讲什么**



- 这里不要讲“谁更高级”，只讲**工作方式变化**。
- 重点不是模型更聪明，而是它开始能在环境里行动。
- Claude Code 官方把它定义为能读代码库、改文件、跑命令的 *agentic coding tool*；OpenAI 对 Codex 的描述也强调它能在隔离环境中读改文件、跑命令、跑测试。 





**过渡句**



> 但“能做事”和“能稳定做事”不是一回事。



------





## **4. 为什么“会做”仍然不稳？**





**标题**

**通用 agent 常见的 4 个失稳点**



**页面上放什么**



- 不知道产物应该长什么样
- 不知道什么叫“做对了”
- 做了一半，下次接不上
- 同样的错误反复犯





右侧可以配一句话：



> **问题往往不在模型不会写代码，**

> **而在它不知道你的任务到底该如何完成。**



**你讲什么**



- Anthropic 讲 long-running agents 时特别强调：复杂任务会跨多个 context window，而新 session 默认没有前情记忆，所以需要 initializer、增量进展和可交接 artifacts。
- Anthropic 也把 context engineering 看成 prompt engineering 的自然延伸：问题不再只是“这次 prompt 怎么写”，而是“整套上下文、工具、历史和外部状态怎么组织”。
- OpenAI 在 Codex 的 harness engineering 文章里还明确说：不要把所有知识塞进一份超长 AGENTS.md，而要给 agent 一个 map 和结构化知识库。 





**过渡句**



> 所以我们需要的不是更多口头提醒，而是一套更好的工作环境。



------





## **5. Harness 是什么？不要先讲抽象定义，先讲四个问题**





**标题**

**一个 harness，本质上回答 4 个问题**



**页面上放什么**

大字放这四问：



1. **AI 看得到什么？**
2. **AI 做得了什么？**
3. **AI 怎么知道做对了？**
4. **AI 下次怎么接着做？**





底部再放一句：



> **Agent = Model + Harness**



**你讲什么**



- 这页不要讲术语史，直接让学生抓住“工作系统”的感觉。
- LangChain 的表述很适合拿来借一句：**A harness is every piece of code, configuration, and execution logic that isn’t the model itself.**
- 也就是说，state、tool execution、feedback loop、constraints，这些基本都属于 harness。 





**过渡句**



> 这样你就能自然引到下一页：prompt 和 harness 到底差在哪？



------





## **6. Prompt engineering 和 harness engineering 的区别**





**标题**

**Prompt 是告诉模型这次怎么说；Harness 是安排模型在什么世界里工作**



**页面上放什么**

建议做成左右表格：

| **Prompt**       | **Harness**                      |
| ---------------- | -------------------------------- |
| 写在消息里       | 写进仓库里                       |
| 解决“这次怎么说” | 解决“长期怎么做”                 |
| 更偏一次性       | 更偏可复用                       |
| 主要靠文字约束   | 还靠脚本、目录、评测、日志、状态 |

页面底部再放一句：



> **Harness ≠ 一份更长的提示词**



**你讲什么**



- Anthropic 明确把 context engineering 视为 prompt engineering 的自然延伸。

- OpenAI 在 Codex 的文章里直接反对“一份超长 AGENTS.md 包打天下”，主张“短 AGENTS.md + 结构化 docs + checked-in plans + 机械校验”。

- 这页讲完，学生应该明白：

  **稳定性通常不是来自更长 prompt，而是来自更好的 repo 环境。** 





**过渡句**



> 那一个“最小 harness”到底长什么样？



------





## **7. 最小 harness：四件套**





**标题**

**一个最小可用 harness，通常只有 4 类东西**



**页面上放什么**

建议四象限：



**1. 结构**



- 目录
- 命名
- 模板





**2. 动作**



- run / build / test / compile
- 一键脚本





**3. 裁判**



- test
- validator
- checker
- benchmark





**4. 记忆**



- progress.md
- iterations.md
- logs / notes





再放一句规则：



> **某个失败会反复出现，就不要只靠提醒，要把它写进 harness。**



**你讲什么**



- 这页是全场最重要的方法页。

- Anthropic 的长时 harness 强调 clear artifacts；LangChain 强调 state、tool execution、feedback loops；Anthropic 的 eval 文章把 grader 分成 code-based、model-based、human 三类。

- 对本科生这里你只要强调：

  **先学会 code-based judge 就已经很有用了。** 





**过渡句**



> 抽象讲到这里就够了，下面直接看一个最小 harness 是怎么长出来的。



------





## **8. 主 demo：为什么我选这个例子？**





**标题**

**主 demo：用 CP_problems 做一道题，不是为了出题，而是为了看清 harness**



**页面上放什么**



- 任务：创建一道算法题
- 产物：题面 + 标程 + generator + validator + 数据
- 成功标准：能跑通 pipeline
- 为什么选它：**结果可见、对错可判、流程清楚**





右边放 repo 树的简化版：



- CLAUDE.md
- testlib.h
- scripts/pipeline.sh
- problems/<problem>/...





**你讲什么**



- CP_problems 本身就是一个很适合教学的 harness：README 写得很清楚，支持 Claude Code 自动创建题目，目录结构标准化，还有一键编译、生成、验证的流水线。
- 你这页就把学生的注意力从“算法题”拉回到“系统怎么让 agent 工作更稳”。 





**过渡句**



> 先不要给它 harness，先看一个“裸 agent”会发生什么。



------





## **9. Demo A：只有 agent，没有 harness**





**标题**

**Demo A：让裸 agent 直接开工**



**页面上放什么**

左边写你准备现场给的任务：



> “请创建一道关于二分查找的算法题，包含题面、标程、generator、validator 和测试数据。”



右边写“观察点”：



- 文件是否落在对的位置？
- 命名是否统一？
- 有没有忘掉 validator / checker？
- 数据是否真的被验证？
- 下次还能不能无痛接着做？





**你讲什么**



- 这页不要追求“它必须失败得很惨”，只要让学生看到：

  **能写出一些东西 ≠ 能形成稳定交付。**

- 你最好提前准备一个半失败案例，这样现场不会失控。





**过渡句**



> 下面我们不是“继续催它”，而是给它搭工作现场。



------





## **10. Demo B：把最小 harness 搭出来，再跑一次**





**标题**

**Demo B：不是加 prompt，而是把工作现场搭好**



**页面上放什么**

直接放你要揭示的 4 个东西：



- CLAUDE.md：规则和约定
- 标准目录结构：产物应该放哪
- pipeline.sh：统一动作入口
- validator / checker：统一成功判定





再放一句：



> **从“请你注意……”**

> **变成“系统会检查……”**



**你讲什么**



- 这里要把学生的注意力放在“环境变化”而不是“模型换了没有”。

- CP_problems 的 README 里已经把这个工作流说明得很完整：AI 会根据 CLAUDE.md 创建目录和文件，再通过 pipeline 编译组件、运行 generate.sh、验证输入并生成输出。

- 这页讲完，学生应该能感受到：

  **harness 的价值，不在于让 agent 更花哨，而在于把步骤变稳定。** 





**过渡句**



> 但 harness 不是一次写完的，它一定是从失败里长出来的。



------





## **11. Demo C：从失败中反向长 harness**





**标题**

**构建 → 使用 → 优化，其实是一个循环**



**页面上放什么**

建议做一张表：

| **观察到的问题** | **不要怎么做** | **应该写进哪里**            |
| ---------------- | -------------- | --------------------------- |
| 命名总出错       | 每次口头提醒   | 模板 / CLAUDE.md            |
| 总忘记跑检查     | 每次重新说一遍 | run.sh / pipeline.sh        |
| 质量波动大       | “你再认真一点” | eval / benchmark / checker  |
| 下次接不上       | 重新解释背景   | progress.md / plans / notes |

再放一句：



> **一旦某个失误会重复出现，它就该从“人脑里的提醒”升级成“仓库里的机制”。**



**你讲什么**



- 这页就是把 demo 抽象成方法论。
- OpenAI 的文章里说得非常像：短 AGENTS.md 只当目录，真正知识写进 repo；计划、进度、决策也应该作为 first-class artifacts check 进仓库，让 agent 能 progressive disclosure 地继续工作。
- Anthropic 的长时 harness 文章也强调：需要留下 clear artifacts 给下一轮 session。 





**过渡句**



> 到这里，“简单 harness”就讲清楚了。接下来只需要让学生看到：同一个思路还能继续长大。



------





## **12. Harness 还能继续长大吗？三个扩展示例**





**标题**

**同一件事的 3 个加强版**



**页面上放什么**

建议做三列，但标题不要写“层”。





### **左：Workflow harness**





**paper-toolkit**



- 标准论文 repo 结构
- meta.yaml
- CLAUDE.md
- phase 迁移
- pt compile / pt review / pt phase







### **中：Optimization harness**





**AKO4ALL**



- setup
- profile
- iterate
- track
- ITERATIONS.md / trajectory/







### **右：Infra harness**





**remote-toolkit**



- SSHFS 挂载远程目录
- SSH + tmux 跑命令
- Claude Code 直接读写远程文件





**你讲什么**



- 这里不要把它们讲成三套新理论。

- 只讲一句本质：

  **你是在把更多原本靠人脑盯着的工作，外包给系统。**

- paper-toolkit 适合讲长时写作 workflow；AKO4ALL 适合讲可测目标下的迭代优化；remote-toolkit 适合讲“agent 连工作现场都够不到时怎么办”。   





**过渡句**



> 但不是所有任务都值得这样做。最后一页方法论之前，先把边界讲清楚。



------





## **13. 什么时候值得搭 harness？什么时候不值得？**





**标题**

**值不值得搭 harness，看这 5 个问题**



**页面上放什么**

建议做 checklist：





### **值得搭**





- 会反复做
- 持续时间长
- 有外部裁判
- 失败成本高
- 需要跨会话续上







### **不太值得搭**





- 一次性任务
- 没有明确好坏判定
- 你手做更快
- 为了“看起来高级”而搭





底部一句：



> **先找最简单、能工作的方案，再决定要不要加复杂度。**



**你讲什么**



- Anthropic 的经验很明确：最成功的 agent 系统往往不是重框架，而是简单、可组合的模式。
- 他们后来做更复杂 harness 时，也反复强调：**先找 simplest solution possible，再按需要加复杂度。** 





**过渡句**



> 所以今天最后要记住的，不是某个工具名，而是一种判断方式。



------





## **14. 收尾：把全场收成 3 句话**





**标题**

**今天带走的 3 句话**



**页面上放什么**



1. **从聊天到 coding agent：不是模型突然更聪明，而是它开始能在环境里行动。**
2. **从 coding agent 到 harness：不是 agent 不行，而是通用环境太松，所以它不够稳。**
3. **一旦某个错误会反复出现，就不要只改 prompt，要把它写进 harness。**





页面最底部再放一句：



> **模型决定上限，harness 决定下限。**



**你讲什么**



- 最后 1 分钟别再扩展新概念。
- 直接收回到主线。
- 然后进入 Q&A。





------





# **3 页可选 appendix**







## **A1. Claude Code / Codex 的最小必要介绍**





放：



- 它们都是 coding agent

- 能读文件、改文件、跑命令

- 有 repo / terminal / IDE 工作心智

  这一页是给从来没接触过的人补底。 







## **A2. 为什么今天不展开讲 MCP / worktree / multi-agent**





放：



- 它们都可以成为 harness 的一部分
- 但不是理解 harness 的前提
- 今天先抓住“任务系统”的骨架







## **A3. 更前沿的方向**





放：



- evaluator agent

- multi-agent handoff

- 更复杂的 scientific / research system

  这一页只是给高阶同学做延伸，不放进主线。





------





# **一个小建议：每页尽量只讲一个命题**





这套 deck 的关键不是信息量，而是**层层递进**：



- 第 3 页回答：**为什么聊天不够**
- 第 4–7 页回答：**为什么 agent 还不够**
- 第 8–11 页回答：**一个 harness 是怎么长出来的**
- 第 12–13 页回答：**它还能长到哪，以及什么时候值得长**





这样学生听起来会像在爬一段楼梯，而不是在看三个并列话题。



下一步最自然的是把这 **14 页**继续展开成**每页可直接贴进 PPT 的标题、bullet 和 speaker notes**。



Q:

但我感觉这样前 40 分钟会不会全是宣讲？而没有动手、演示的内容？



A:

对，你这个担心是对的。**前 40 分钟如果都在讲概念，现场会很“像课”，不像技术沙龙。**

尤其是本科生场子，最好做到两件事：



**前 8 分钟内让大家看到 agent 在干活。**

**前 25 分钟内让大家看到 harness 确实改变了结果。**



所以我会把前面的结构改成：





## **不是“先讲 40 分钟，再 demo”**





而是：



**先演一个问题 → 再解释为什么会这样 → 再现场补 harness → 再看结果变了没有。**



这样逻辑还在，而且更顺。因为你讲的不是抽象概念，而是“刚才这个失败为什么发生”。



------





## **最关键的改法：用“同一个任务”贯穿前三段**





这是把三条线串起来的最好办法。



你不要先分别讲：



- 工具差异
- harness 是什么
- 构建 / 使用 / 优化





而是用**同一个任务**做三次：



1. **聊天式 AI 做这个任务**
2. **裸 Claude Code 做这个任务**
3. **带 harness 的 Claude Code 做这个任务**





这样三条线会自动合一：



- **工具线**：为什么聊天不够，为什么要 coding agent
- **harness 线**：为什么 coding agent 还不够，为什么要 harness
- **构建-使用-优化线**：harness 怎么一点点长出来





也就是说，学生看到的不是三套理论，而是**同一件事在三个环境里逐步升级**。



------





# **我建议的前 40 分钟改成这样**







## **0–5 分钟｜一句话开场 + 任务宣布**





只讲两件事：



第一句：



> 今天不是来学 Claude Code 技巧，而是看：同一个任务，为什么从聊天窗口到 coding agent 再到 harness，效果会越来越稳定。



第二句：



> 我们用一个具体任务贯穿全场。



任务建议还是用 **CP_problems 风格任务**，因为最可验证。

比如：



> “请帮我创建一道算法题，包含题面、标准解、数据生成器、validator、测试数据，并确保整个 pipeline 能跑通。”



这时不要讲 harness 定义，不要讲抽象框架。



------





## **5–12 分钟｜第一次演示：聊天式 AI / 纯对话方式**





这里不一定真的切去网页版 ChatGPT。你可以直接口头模拟，或者提前截几张图。重点不是产品本身，而是**使用方式**。



你展示：



- 它能给你题面
- 能给你代码片段
- 能给你 generator 草稿
- 但这些东西是“散的”
- 你要自己粘贴、自己落文件、自己跑、自己查错





然后立刻下一个结论：



> 它不是不能帮你做，

> 但它主要是在“给建议”，不是在“替你完成工作流”。



这个阶段 7 分钟足够。



------





## **12–22 分钟｜第二次演示：裸 Claude Code / 通用 coding agent**





现在切到 Claude Code。



给它同样的任务，让它：



- 建目录
- 写题面
- 写 std
- 写 generator
- 写 validator
- 尝试跑一下





这一步非常关键：**不要追求成功，要追求暴露问题。**



你甚至可以提前准备一个“半失败结果”，避免现场不可控。

让大家看到这种典型问题：



- 目录结构不标准
- 文件命名不一致
- 缺少某个必要文件
- pipeline 不存在
- 生成器和 validator 没真正接起来
- 下次回来它也不知道当前状态到哪了





这时候你说一句全场很重要的话：



> 裸 agent 的问题，不是它不会写代码，

> 而是它不知道“这件事在你的环境里怎样才算做完”。



到这里，学生已经自然懂了：**coding agent 比聊天更强，但还是不稳。**



------





## **22–30 分钟｜第一次抽象：harness 不是概念，是“把工作现场搭好”**





直到这里，才引入 harness。



但不要定义成“环境层、流程层、评测层”这种抽象词。

直接接着刚才的问题讲：



> 刚才它为什么不稳？因为有四件事没被外化：



1. > 它该看什么

2. > 它该怎么做

3. > 它怎么知道做对了

4. > 下次怎么接着做





然后给出一句最容易记住的定义：



> **harness = 模型之外，让 agent 稳定工作的那套东西。**



接着再补一句：



> **prompt 是告诉它这次该怎么说，harness 是安排它在什么世界里工作。**



注意，这里 8 分钟就够了。因为前面已经看过失败了，现在这个定义会特别自然。



------





## **30–40 分钟｜第三次演示：现场补一个最小 harness，然后再跑**





这是前 40 分钟的高潮。



你只补最小的几样东西，不要从 0 写一大堆：



- CLAUDE.md
- 固定目录结构
- pipeline.sh
- 一个简单的检查机制
- 可能再加一个 progress.md





然后重新让 Claude Code 跑同类任务。



这时学生会立刻看到区别：



- 输出落到标准位置
- 它知道该调哪个脚本
- 它知道验什么
- 出错时更容易定位
- 下次继续做也更容易接上





然后你给出一个极其重要的工程结论：



> **一旦某个错误会反复出现，就不要再靠口头提醒，而要把它写进 harness。**



到这里，前 40 分钟就不是宣讲了，而是已经完整经历了：



**聊天 → agent → harness**

**失败 → 解释 → 修补 → 重跑**



这会非常顺。



------





# **这样一来，后面的 80 分钟怎么接？**





后面就会容易很多，因为最难的逻辑已经在前 40 分钟里被“演出来了”。



------





## **40–55 分钟｜把刚才的 demo 提炼成方法**





这时才适合做第一次系统总结。



你只总结四样东西：



- **结构**：目录、模板、命名
- **动作**：脚本、命令、工具
- **裁判**：validator、eval、benchmark
- **记忆**：progress、notes、iterations、logs





然后告诉大家：



> 任何 harness，本质上都在补这四件事。



这样，“harness 是什么”就不抽象了，因为大家刚看过。



------





## **55–75 分钟｜简单 harness：workflow harness**





这时你再讲 paper-toolkit，学生就能听懂了。



你可以说：



> 刚才我们给出题任务搭了一个最小 harness。

> 如果任务换成论文写作，思路是不是一样？



然后展示：



- 固定 repo 结构
- phase
- compile/review/rebuttal
- meta.yaml
- CLAUDE.md





这里你的重点不是讲论文自动写作，而是讲：



> **workflow harness 的核心，是把重复流程固定下来。**



这样 3 这一层就立住了。



------





## **75–95 分钟｜更进一步：optimization harness**





这时再讲 AKO4ALL 就自然了。



因为前面大家已经理解：



- harness 可以让工作更稳
- workflow 可以被固化





那接下来只差一步：



> 如果任务有明确指标，harness 能不能不只是“稳”，还能“自己迭代变好”？



这就是 optimization harness。



你强调的不是 kernel 细节，而是这几个结构：



- baseline
- benchmark
- profile
- iterate
- track





一句话概括：



> **workflow harness 固化的是流程，optimization harness 固化的是反馈闭环。**



这样 4 这一层也顺了。



------





## **95–105 分钟｜再进一步：infra harness**





这时讲 remote-toolkit。



因为大家已经理解两件事：



- 流程可以被固化
- 评测可以被固化





接下来再说：



> 但有时候问题甚至不是流程不清楚，而是 agent 根本够不到工作现场。



于是引出：



- 远程目录挂载
- 长时任务不掉线
- 远程环境变成 agent 可操作的现场





一句话概括：



> **infra harness 固化的是工作环境本身。**



这样 5 这一层也顺了。



------





## **105–115 分钟｜什么时候值得搭 harness**





最后才讲边界：



- 一次性小任务，不值得
- 重复任务，值得
- 长时任务，值得
- 有外部反馈，值得
- 失败成本高，值得





这里就回到你最开始的判断了：



> 不是每个任务都要特化 harness，

> 但长时间、会反复做、而且希望越来越稳的任务，很值得。



------





## **115–120 分钟｜结尾只收三句话**





1. **聊天式 AI 解决的是“会说”。**
2. **coding agent 解决的是“会做”。**
3. **harness 解决的是“做得稳，而且能复用”。**





最后一句金句：



> **模型决定上限，harness 决定下限。**



------





# **所以，答案是：**





**对，前 40 分钟不能全是宣讲。**

但不是把概念砍掉，而是把概念**嵌进演示的因果链里**。



最好的结构不是：



> 先讲概念，再 demo



而是：



> **先让它失败，再解释为什么失败，再补 harness，再看它变稳。**



------





# **我建议你记住一个最简单的排课原则**





**每讲 8–12 分钟，就让屏幕上发生一件事。**



比如：



- 第 10 分钟：第一次看到 agent 干活
- 第 20 分钟：第一次看到裸 agent 失败
- 第 35 分钟：第一次看到 harness 改变结果
- 第 60 分钟：第一次看到这种思路迁移到另一个任务
- 第 85 分钟：第一次看到“自动优化”闭环
- 第 100 分钟：第一次看到“环境本身也是 harness”





这样整场课就会非常像技术沙龙，而不是“概念宣讲”。



我可以下一条直接把这版重排成一个**真正可讲的 2 小时时间表**，精确到每 10 分钟讲什么、演什么、屏幕上打开哪些文件。