# iOS 真机调试问题排查指南

## 常见问题及解决方案

### 1. 证书和签名问题（最常见）

**问题表现**：
- App 无法安装到真机
- 安装后闪退
- 签名验证失败

**解决方案**：
1. 打开 Xcode -> Preferences -> Accounts
2. 检查 Apple Developer 账号是否有效
3. 确保证书没有过期或被撤销
4. 更新项目的 Signing & Capabilities：
   - Team: 选择你的开发者账号
   - Bundle Identifier: 确保与 App ID 一致
   - 自动管理签名（推荐）

### 2. 设备未注册

**问题表现**：
- "Unable to install" 错误

**解决方案**：
1. 在 Apple Developer 网站添加设备 UUID
2. 更新 Provisioning Profile
3. 重新下载并安装描述文件

### 3. 网络问题（可能导致登录失败）

**问题表现**：
- App 可以打开但无法登录
- 登录按钮无响应或超时

**解决方案**：

#### A. 检查网络权限
在 `Info.plist` 中确保：
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### B. 真机网络环境
- 确保真机连接的 WiFi 可以访问腾讯云服务器
- 尝试切换到移动数据测试
- 检查是否有公司/学校网络限制

### 4. SDK 配置问题

**问题表现**：
- 登录返回错误码
- 显示网络连接失败

**解决方案**：

检查 `GenerateTestUserSig.h` 文件：
```cpp
// 确保 SDKAppID 正确
#define SDKAppID 1400xxxxxx  // 替换为你的实际 SDKAppID

// 确保密钥正确
#define SECRETKEY @"xxxxxxxx"  // 替换为你的实际密钥
```

### 5. 后端服务器问题

**问题表现**：
- 模拟器正常，真机异常
- 特定网络环境下失败

**解决方案**：
1. 检查是否使用代理或 VPN
2. 确认腾讯云 IM 控制台配置正确
3. 查看 Xcode 控制台的具体错误信息

---

## 快速诊断步骤

### Step 1: 查看 Xcode 控制台日志

1. 连接真机到电脑
2. 打开 Xcode -> Window -> Devices and Simulators
3. 查看 Console 输出
4. 搜索错误关键词：`error`、`failed`、`login`

### Step 2: 检查设备日志

```bash
# 在终端中查看真机日志
ideviceinstaller -u <设备UUID> -l  # 列出已安装应用
idevicesyslog  # 查看实时日志
```

### Step 3: 测试基础网络连通性

在 Safari 中打开：
```
https://console.tim.qq.com
```

如果无法访问，说明网络有问题。

---

## 最可能的解决方案

### 方案 A: 重新配置签名

1. Xcode 中选择项目 -> TARGETS -> TUIKitDemo
2. Signing & Capabilities -> 取消勾选 "Automatically manage signing"
3. 重新勾选，等待 Xcode 自动配置
4. 选择正确的 Team

### 方案 B: 清理构建缓存

```bash
# 在终端执行
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf ~/Library/Caches/com.apple.dt.Xcode
```

然后重新打开 Xcode 并构建。

### 方案 C: 检查 UserSig 生成

如果登录失败，可能是 `GenerateTestUserSig` 生成的用户签名有问题。

确保 `GenerateTestUserSig.h` 中的：
- `SDKAppID` 是你在腾讯云创建的 App ID
- `SECRETKEY` 是对应的密钥（不要泄露！）

---

## 获取更多帮助

请提供以下信息以便进一步诊断：

1. **Xcode 控制台错误信息**：连接真机后运行 App，复制完整的错误日志
2. **具体表现**：
   - App 完全打不开？（闪退）
   - 还是可以打开但登录按钮没反应？
   - 或者登录后立即退出？
3. **错误代码**：如果显示错误码（如 6001, 7001 等）

---

## 临时解决方案：使用 TestFlight 或 Ad Hoc

如果只是测试需求，可以：
1. 在 Apple Developer 网站创建 Ad Hoc 描述文件
2. 导出 IPA 并安装到真机
3. 绕过部分签名限制
