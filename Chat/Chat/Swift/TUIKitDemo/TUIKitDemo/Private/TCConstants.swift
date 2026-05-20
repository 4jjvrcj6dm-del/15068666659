// tuikit/ios/TUIKitDemo_Swift/TUIKitDemo/Private/TCConstants.swift

import Foundation

// Global dispatch service host, for China mainland.
let kGlobalDispatchServiceHost = ""
let kApaasAppID = "4"
// Global dispatch service host, for international areas.
let kGlobalDispatchServiceHost_international = ""
let kApaasAppID_international = ""
// Global dispatch service path
let kGlobalDispatchServicePath = ""

// Environment for development.
let kEnvDev = "/dev"
// Environment for production.
let kEnvProd = "/prod"

// Get SMS verification code.
let kGetSmsVerfifyCodePath = ""
// Login by phone.
let kLoginByPhonePath = ""
// Login by token.
let kLoginByTokenPath = ""
// Logout.
let kLogoutPath = ""
// Delete user.
let kDeleteUserPath = ""

// Http server address.
let kHttpServerAddr = ""

// CloudBase 配置
let kCloudBaseEnvID = "ai-native-d6gbsrs0rb0dce53d"
let kCloudBaseBaseURL = "https://ai-native-d6gbsrs0rb0dce53d.api.tcloudbasegateway.com"
let kCloudBaseFunctionName = "userAuth"
// Publishable Key - 请从 CloudBase 控制台获取
let kCloudBasePublishableKey = "eyJhbGciOiJSUzI1NiIsImtpZCI6IjlkMWRjMzFlLWI0ZDAtNDQ4Yi1hNzZmLWIwY2M2M2Q4MTQ5OCJ9.eyJpc3MiOiJodHRwczovL2FpLW5hdGl2ZS1kNmdic3JzMHJiMGRjZTUzZC5hcC1zaGFuZ2hhaS50Y2ItYXBpLnRlbmNlbnRjbG91ZGFwaS5jb20iLCJzdWIiOiJhbm9uIiwiYXVkIjoiYWktbmF0aXZlLWQ2Z2JzcnMwcmIwZGNlNTNkIiwiZXhwIjo0MDgyOTY2MjQ1LCJpYXQiOjE3NzkyODMwNDUsIm5vbmNlIjoidVNrUkEyaXVTQlNLOGV4ZVhSWHR4dyIsImF0X2hhc2giOiJ1U2tSQTJpdVNCU0s4ZXhlWFJYdHh3IiwibmFtZSI6IkFub255bW91cyIsInNjb3BlIjoiYW5vbnltb3VzIiwicHJvamVjdF9pZCI6ImFpLW5hdGl2ZS1kNmdic3JzMHJiMGRjZTUzZCIsIm1ldGEiOnsicGxhdGZvcm0iOiJQdWJsaXNoYWJsZUtleSJ9LCJ1c2VyX3R5cGUiOiIiLCJjbGllbnRfdHlwZSI6ImNsaWVudF91c2VyIiwiaXNfc3lzdGVtX2FkbWluIjpmYWxzZX0.GQnonKkhpr3YG9Fk7SoXnW1J9jOZGxUqBWgWrNnOnfhPJZC7c_bb_BnaMPLgw9FXFkJzGr-bUPuk4XhGspVtQ-vTUewaNV_FRkRZelPuf4a-mNfvsBci3rxLbIiNaobkw0IdaM5VXbQzBmdvRl7oLvHJ7ZUMs0ymTjVFZS35ewohv-y5jmEEYUnCDmy2KX1VLuuorNczkP3Ftug3CU9qZQwaIh82Ai35ZB8zvuVgr93Q5wuaI-TKrHI6h7UQOLb1LyFpRaciy6UCgRrR8wk4uTdoqim3qjRvBSJQs1bRBPmDww_tStpKu9zkNKFCa2TuoNs_cIxytwes1yqqfVrzPQ"

// Elk host.
let DEFAULT_ELK_HOST = ""

// Licence url.
let LicenceURL = ""

// Licence key.
let LicenceKey = ""

#if BUILDINTERNATIONAL

#if DEBUG
let kAPNSBusiId = 0 // Debug locally, using certificate of xi'an dev.
#else
#if BUILDAPPSTORE
let kAPNSBusiId = 0 // Compile for Appstore in Landun, using distribution certificate of keystore. Contact harvy if needed.
#else
let kAPNSBusiId = 0 // Compile for Enterprise in Landun, using distribution certificate of keystore. Contact harvy if needed.
#endif
#endif

#else
// Mainland: Shenzhen's certificate id:15108/16205, Xi'an's certificate id:29064(default)
#if DEBUG
let kAPNSBusiId = 0 // Debug locally, using certificate of xi'an dev.
#else
#if BUILDAPPSTORE
let kAPNSBusiId = 0 // Compile for Appstore in Landun, using distribution certificate of keystore. Contact harvy if needed.
#else
let kAPNSBusiId = 0 // Compile for Enterprise in Landun, using distribution certificate of keystore. Contact harvy if needed.
#endif
#endif
#endif

#if DEBUG
let kTIMPushAppGroupKey = "" // Debug locally key
#else
#if BUILDAPPSTORE
let kTIMPushAppGroupKey = "g" // Compile for Appstore in Landun
#else
let kTIMPushAppGroupKey = "" // Compile for Enterprise in Landun
#endif
#endif

// tpns
#if BUILDINTERNATIONAL
let kTPNSAccessID = 0
let kTPNSAccessKey = ""
#else
let kTPNSAccessID = 0
let kTPNSAccessKey = ""
#endif

// tpns domain
#if BUILDINTERNATIONAL
let kTPNSDomain = ""
#else
let kTPNSDomain = ""
#endif

//**********************************************************************

let kHttpTimeout: TimeInterval = 30

// Error code.
let kError_InvalidParam = -10001
let kError_ConvertJsonFailed = -10002
let kError_HttpError = -10003

// Error code related to group in IMSDK.
let kError_GroupNotExist = 10010  // Group is dismissed.
let kError_HasBeenGroupMember = 10013  // Already a member of the group.

// Error message.
let kErrorMsgNetDisconnected = "The network is disconnected, please check the network"

// Version.
let kVersion = 4
