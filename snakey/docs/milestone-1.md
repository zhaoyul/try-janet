# 里程碑 1：核心乐趣（可变速度 + 平滑转向 + 计分/连击 + 基础 HUD）

目标与约束
- 平台/框架：Janet + jarylib（桌面端优先）。
- 移动方式：非网格连续运动；不允许穿墙；自体碰撞判定。
- 美术风格：矢量、圆角、可爱配色（高可读、低噪点）。
- 取向：竞技优先（手感响应、判定一致、可复盘）。

交付物
- 连续运动与平滑转向（固定/可调转向速率），基于 dt 的时间步。
- 变量速度（随吃食物或连击加速），含上限与衰减策略（可选）。
- 身体跟随（等间距骨架/脊柱采样），稳定的身体长度维护。
- 碰撞判定：边界（AABB + 半径）、自体（段-圆距离，跳过最近若干段）。
- 计分与连击：基础分 × 倍率；连击槽（时间衰减），HUD 展示。
- 基础 HUD：分数、连击倍数、速度、连击槽。
- 轻量反馈：吃到粒子、微弱震屏（可调）、得分飘字。

技术任务
1) 时间步与速度
- 引入 `dt`（秒）驱动更新；对极端帧率夹紧 `dt ∈ [1/240, 1/30]`。
- 参数：`base_speed`、`max_speed`、`speed_gain_per_food`、`speed_decay_per_s`（可 0）。

2) 平滑转向与输入
- 输入解析为目标单位向量 `target_dir`（上下左右或摇杆向量）。
- 当前速度方向 `vel_dir` 以最大角速度 `turn_rate_deg` 朝 `target_dir` 旋转（slerp/限幅）。
- 禁止瞬间 180° 反向；若角度>160°，采用最大允许转向并延迟到下一帧继续。
- 参数：`turn_rate_deg`、`deadzone`（手柄）、`input_buffer_ms`（可选）。

3) 身体模拟（非网格）
- 维护“脊柱”路径点列表 `spine`（头部轨迹采样），采样间隔由 `body_spacing` 控制。
- 头部按 `vel_dir * speed * dt` 前进，将新点推入；移除多余点以保持总长度 = `head_radius + body_spacing * (segments-1)`。
- 渲染时按 `spine` 采样生成等距节段位置；保证拐弯处圆滑（Catmull-Rom/线性采样均可，先用线性）。
- 参数：`head_radius`、`body_spacing`、`segment_count`（由长度/得分派生）。

4) 碰撞判定
- 边界：若 `head_pos +/- head_radius` 越界则判定失败（不允许穿墙）。
- 自体：对 `spine` 的折线段做“点到线段距离”检测，若 < `2*head_radius` 则碰撞。
- 优化：跳过最近 `collision_skip_segments` 段；每帧检查 N 段上限或使用简易网格分桶。
- 参数：`collision_skip_segments`、`self_hit_margin`（微调容错）。

5) 计分与连击
- 基础得分：吃食物 +X；连击倍数 `mult` 从 1 开始。
- 连击槽 `combo_gauge`（0..1）：随事件增加、随时间以 `combo_decay_per_s` 衰减；
  - 阈值：`[0.25, 0.5, 0.75, 1.0]` 分别使 `mult` 变为 `[1.5, 2, 3, 4]`（示例）。
  - 槽清空则 `mult` 退级；进阶可关联 `speed_bonus_from_combo`（上限受 `max_speed` 约束）。
- HUD：显示分数、`mult`、速度（单位格/秒或 px/s）、连击槽进度。
- 参数：`score_per_food`、`combo_add_per_food`、`combo_decay_per_s`、`combo_thresholds`、`combo_mults`。

6) 反馈与表现（轻量）
- 吃食：圆点散射粒子（颜色取自“可爱配色”），1 次屏震（`shake_scale`）。
- 完美转角（角速度达到上限且未碰撞时）：短暂描边高亮头部/首段。
- 飘字：+分数 与 xN 倍率短时显示。
- 参数：`shake_scale`、`particle_life`、`particles_per_eat`。

7) 配色与样式
- 启动主题 `cute`：柔和粉/薄荷/奶油黄/天蓝/薰衣草。
- 矢量渲染：圆角线段，头尾端帽为圆形；背景弱网格或纯色。
- 暴露颜色表：`palette.cute = { bg, snake, snake_alt, food, hud_fg, hud_dim }`。

8) 调试与复盘
- `F1`：显示/隐藏调试：fps、dt、速度、碰撞半径、spine 点。
- `F2`：慢动作 0.5x；`F3`：固定时间步演示（便于复盘确定性）。

参数建议（默认值）
- `base_speed = 140`
- `max_speed = 320`
- `speed_gain_per_food = 14`
- `speed_decay_per_s = 0`
- `turn_rate_deg = 540`  （每秒最大转向 540°，手感灵）
- `head_radius = 8`
- `body_spacing = 6`
- `collision_skip_segments = 10`
- `score_per_food = 10`
- `combo_add_per_food = 0.34`
- `combo_decay_per_s = 0.22`
- `combo_thresholds = [0.25, 0.5, 0.75, 1.0]`
- `combo_mults = [1.5, 2, 3, 4]`
- `shake_scale = 0.6`
- `particles_per_eat = 12`

代码落点与建议接口
- 配置：在 `set.janet` 增加 `game.config` 表，包含上述参数与 `palette.cute`。
- 状态：在 `main.janet` 或 `game` 模块维护 `state`：`pos`, `vel_dir`, `speed`, `spine`, `score`, `combo_gauge`, `combo_mult`。
- 更新：`game/update dt input state` 实现 1–5 小节逻辑；`game/draw state` 负责蛇/食物/HUD。
- 事件：`game/on-eat state` 增加分数、连击、速度，并触发粒子/震屏。

验收标准（可运行 / 可观感）
- 蛇以连续非网格方式移动，快速转向流畅无抖动，无瞬时 180°。
- 吃 3–5 个食物后明显提速，但不超过 `max_speed`；HUD 实时反映速度与连击。
- 自体碰撞在高速度下仍然稳定重现；边界必定阻挡。
- 30–240 FPS 区间手感一致（dt 夹紧验证）。
- Debug 显示可视化 spine 与碰撞半径，便于调参。

测试清单
- 低/高帧率模拟：注入 `dt=1/30` 与 `1/240` 跑 10 秒无数值爆炸。
- 高速蛇进入 U 形弯：不穿模，自体碰撞可靠。
- 连吃 5 次：倍率与速度符合参数期望，槽衰减正确。
- 暂停/继续后速度、连击槽保持一致，不发生跳变。

备注
- 回放/幽灵暂不在本里程碑；若易做，可记录输入 + 随机种子，后续启用。
