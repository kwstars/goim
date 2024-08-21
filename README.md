## 快速开始指南

### 前置需求

在开始之前，请确保您的系统已安装以下工具：

1. **Go 语言**: 本项目使用 Go 语言开发。请安装 Go 1.16 或更高版本。

   - 下载和安装说明：https://golang.org/doc/install

2. **Docker 和 Docker Compose**: 用于容器化服务和编排。

   - Docker 安装指南：https://docs.docker.com/get-docker/
   - Docker Compose 安装指南：https://docs.docker.com/compose/install/

3. **Git**: 用于版本控制和子模块管理。
   - 下载和安装说明：https://git-scm.com/downloads

请确保这些工具已正确安装并可以在命令行中使用。

### 步骤

按照以下步骤来设置和运行项目：

1. **初始化项目**

   运行以下命令来初始化项目，包括更新子模块和设置必要的配置：

   ```bash
   $ make init
   ```

2. **构建项目**

   使用以下命令构建项目：

   ```bash
   $ make build
   ```

3. **运行服务**

   启动所有必要的服务：

   ```bash
   $ make run
   ```

4. **检查状态**

   验证所有服务是否正在运行：

   ```bash
   $ make status
   Discovery is running
   Comet is running
   Logic is running
   Job is running
   ```

5. **运行示例**

   在新的终端窗口中，运行 JavaScript 示例：

   ```bash
   $ (cd goim/examples/javascript && go run main.go)
   ```

6. **访问示例**

   在游览器打开 `http://<HOST_IP>:1999`

### 额外信息

- **Kafka UI**: 您可以通过以下地址访问 Kafka UI：
  http://localhost:8090
- **Redis Client**: 推荐使用 [Another Redis Desktop Manager](https://github.com/qishibo/AnotherRedisDesktopManager)

### 注意事项

- 如果遇到任何问题，请检查控制台输出以获取错误信息。
- 对于开发环境，请确保所有必要的端口都是可用的。
- 如果您在 Windows 环境下开发，可能需要使用 WSL2 (Windows Subsystem for Linux 2) 来运行 Docker 和执行 make 命令。
