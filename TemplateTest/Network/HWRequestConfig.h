//
//  HWRequestConfig.h
//  Template-OC
//
//  Created by niedi on 15/4/3.
//  Copyright (c) 2015年 caijingpeng.haowu. All rights reserved.
//

#ifndef Template_OC_HWRequestConfig_h
#define Template_OC_HWRequestConfig_h


#define kPageCount                      10                   //每页请求数据数
#define kFirstPage                      1                   // 默认第一页

#define kNetworkFailedMessage           @"网络不给力,请稍后再试!"

#define kStatusLogout                   -99
#define kStatusSuccess                  0 //请求成功
#define kStatusNetworkFailed            404


#define kUrlBase                    @"http://116.62.202.152/api/mouth/pat/index.php/"

#define kHtmlBase                   @"http://116.62.202.152/api/mollin/h5/index.php"
//Https
//#define kUrlBase                    GET_USERDEFAULT(@"urlBase")
//#define kImageBaseUrl               GET_USERDEFAULT(@"imageBaseUrl")
//#define kMoneyBaseUrl               GET_USERDEFAULT(@"moneyBaseUrl")
//#define kPHPUrlBase                 GET_USERDEFAULT(@"PHPUrlBase")
//#define kxmppServer                 GET_USERDEFAULT(@"xmppServer")


//请求域名接口
#define kGetDomain                  @"index/getCustomerDomain.do"

#define kUploadImage                 @"" //上传图片
#define kLogin                      @"acc/loginByCode"//登录
//#define kRegister                   @"Account/DoRegister"//注册
#define kGetVerifyCode              @"acc/getVerifyCode"//获取验证码
#define kModifyPassword             @"Member/DoUpMember" //修改密码
#define kSupplementInfo             @"Member/DoUpMember"//完善账号信息
#define kHomePage                   @"main/loadMainPages"//首页
#define kAppointList                @"apl/applyList" //我的预约列表
#define kAppointDetail              @"apl/applyInfo"//预约详情
//H5链接

#define AppendHTML(shortUrl)   [NSString stringWithFormat:@"%@%@?userKey=%@",kHtmlBase,shortUrl,[HWUserLogin currentUserLogin].userkey]

#define kHomeH5                     AppendHTML(@"/Orders/Index")     //总览
#define kOrder                      AppendHTML(@"/Orders/OrderList") //订单
#define kCommission                 AppendHTML(@"/Orders/Brokerage") //提成
#define kPeopleCenter               AppendHTML(@"/Member/Index")     //个人中心
#define kProductCenter              AppendHTML(@"/Products/Index")    //产品中心
#define kUserHome                   AppendHTML(@"/Member/MemberNews")

#define kLoginGainVertifyCode        @"" //获取验证码
#define kLoginApp                    @"" //登录
#define kDetectionCapturePhotos      @"chk/checkImageList" // 牙菌检测-已检测照片
#define kDetectionDeletePhoto        @"chk/delCheckImage" // 牙菌检测-删除图片
#define kDetectionResult             @"chk/finishUploadImg" // 牙菌斑检测--结果
#define kRecommandDoctor             @"chk/dencitsQuery" // 牙菌斑检测 -推荐附近的医生
#define kRDoctorDetail               @"chk/dentistInfo" // 牙菌斑检测 -医生详情
#define kRDoctorOrder                @"apl/applyDentist"// 牙菌斑检测 - 预约
#define kCaseList                    @"fam/loadCheckList" //病例列表
#define kCaseDetail                  @"fam/checkDetail" //病例详情
#define kFamilyMembers               @"fam/loadMyFamily" //病例详情
#endif



