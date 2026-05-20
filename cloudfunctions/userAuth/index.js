// 用户认证云函数 - 处理注册、登录、密码找回等操作
const cloudbase = require("@cloudbase/node-sdk");
const crypto = require("crypto");

const app = cloudbase.init({
  env: cloudbase.SYMBOL_CURRENT_ENV,
});
const db = app.database();
const usersCollection = db.collection("users");

// 密码哈希（和 iOS 端 simpleHash 保持兼容）
function hashPassword(password) {
  let hash = 5381;
  for (let i = 0; i < password.length; i++) {
    hash = ((hash << 5) + hash) + password.charCodeAt(i);
    hash = hash >>> 0; // 转为无符号整数
  }
  return hash.toString(16);
}

// 验证手机号（中国大陆）
function isValidPhone(phone) {
  return /^1[3-9]\d{9}$/.test(phone);
}

exports.main = async (event, context) => {
  try {
    // 从 HTTP 请求中获取参数
    const params = typeof event.body === "string" ? JSON.parse(event.body) : event.body || event;
    const { action } = params;

    if (!action) {
      return { code: -1, message: "缺少 action 参数" };
    }

    switch (action) {
      // ===== 注册 =====
      case "register": {
        const { phone, username, password } = params;
        if (!phone || !username || !password) {
          return { code: -1, message: "请提供完整的注册信息（phone、username、password）" };
        }
        if (!isValidPhone(phone)) {
          return { code: -1, message: "请输入正确的手机号" };
        }
        if (username.trim().length < 3) {
          return { code: -1, message: "用户名长度需至少3位" };
        }
        if (password.length < 6 || password.length > 20) {
          return { code: -1, message: "密码长度需为6-20位" };
        }

        // 检查手机号是否已注册
        const phoneResult = await usersCollection.where({ phone }).get();
        if (phoneResult.data.length > 0) {
          return { code: -1, message: "该手机号已注册" };
        }

        // 检查用户名是否已存在
        const usernameResult = await usersCollection.where({ username: username.trim() }).get();
        if (usernameResult.data.length > 0) {
          return { code: -1, message: "该用户名已被使用" };
        }

        // 创建新用户
        const newUser = {
          phone: phone.trim(),
          username: username.trim(),
          passwordHash: hashPassword(password),
          createdAt: new Date(),
          lastLoginAt: null,
        };
        const addResult = await usersCollection.add(newUser);

        return {
          code: 0,
          message: "注册成功",
          data: { id: addResult.id, username: username.trim() },
        };
      }

      // ===== 用户名 + 密码登录 =====
      case "loginByUsername": {
        const { username, password } = params;
        if (!username || !password) {
          return { code: -1, message: "请提供用户名和密码" };
        }

        const result = await usersCollection.where({ username: username.trim() }).get();
        if (result.data.length === 0) {
          return { code: -1, message: "该用户名未注册" };
        }

        const user = result.data[0];
        if (user.passwordHash !== hashPassword(password)) {
          return { code: -1, message: "密码错误" };
        }

        // 更新最后登录时间
        await usersCollection.doc(user._id).update({ lastLoginAt: new Date() });

        return {
          code: 0,
          message: "登录成功",
          data: { userId: username.trim(), phone: user.phone, username: user.username },
        };
      }

      // ===== 手机号 + 密码登录 =====
      case "loginByPhone": {
        const { phone, password } = params;
        if (!phone || !password) {
          return { code: -1, message: "请提供手机号和密码" };
        }

        const result = await usersCollection.where({ phone }).get();
        if (result.data.length === 0) {
          return { code: -1, message: "该手机号未注册" };
        }

        const user = result.data[0];
        if (user.passwordHash !== hashPassword(password)) {
          return { code: -1, message: "密码错误" };
        }

        // 更新最后登录时间
        await usersCollection.doc(user._id).update({ lastLoginAt: new Date() });

        return {
          code: 0,
          message: "登录成功",
          data: { userId: user.username, phone: user.phone, username: user.username },
        };
      }

      // ===== 检查手机号是否存在 =====
      case "checkPhone": {
        const { phone } = params;
        if (!phone) {
          return { code: -1, message: "请提供手机号" };
        }
        const result = await usersCollection.where({ phone }).get();
        return {
          code: 0,
          message: result.data.length > 0 ? "手机号已注册" : "手机号可用",
          data: { exists: result.data.length > 0 },
        };
      }

      // ===== 检查用户名是否存在 =====
      case "checkUsername": {
        const { username } = params;
        if (!username) {
          return { code: -1, message: "请提供用户名" };
        }
        const result = await usersCollection.where({ username: username.trim() }).get();
        return {
          code: 0,
          message: result.data.length > 0 ? "用户名已存在" : "用户名可用",
          data: { exists: result.data.length > 0 },
        };
      }

      // ===== 重置密码（用户名+手机号双重验证） =====
      case "resetPassword": {
        const { username, phone, newPassword } = params;
        if (!username || !phone || !newPassword) {
          return { code: -1, message: "请提供用户名、手机号和新密码" };
        }
        if (newPassword.length < 6 || newPassword.length > 20) {
          return { code: -1, message: "密码长度需为6-20位" };
        }

        const result = await usersCollection.where({ username: username.trim() }).get();
        if (result.data.length === 0) {
          return { code: -1, message: "该用户名未注册" };
        }

        const user = result.data[0];
        if (user.phone !== phone) {
          return { code: -1, message: "用户名与手机号不匹配" };
        }

        // 更新密码
        await usersCollection.doc(user._id).update({ passwordHash: hashPassword(newPassword) });

        return { code: 0, message: "密码重置成功" };
      }

      // ===== 获取用户信息 =====
      case "getUserInfo": {
        const { username } = params;
        if (!username) {
          return { code: -1, message: "请提供用户名" };
        }
        const result = await usersCollection.where({ username: username.trim() }).get();
        if (result.data.length === 0) {
          return { code: -1, message: "用户不存在" };
        }
        const user = result.data[0];
        return {
          code: 0,
          message: "成功",
          data: {
            phone: user.phone,
            username: user.username,
            createdAt: user.createdAt,
            lastLoginAt: user.lastLoginAt,
          },
        };
      }

      default:
        return { code: -1, message: `未知的 action: ${action}` };
    }
  } catch (error) {
    console.error("云函数执行错误:", error);
    return { code: -1, message: "服务器内部错误: " + error.message };
  }
};
