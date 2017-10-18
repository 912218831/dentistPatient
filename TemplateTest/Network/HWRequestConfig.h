//
//  HWRequestConfig.h
//  Template-OC
//
//  Created by niedi on 15/4/3.
//  Copyright (c) 2015年 caijingpeng.haowu. All rights reserved.
//

#ifndef Template_OC_HWRequestConfig_h
#define Template_OC_HWRequestConfig_h


#define kPageCount                     @"10"                   //每页请求数据数
#define kFirstPage                     @"1"                   // 默认第一页

#define kNetworkFailedMessage           @"网络不给力,请稍后再试!"

#define kStatusLogout                   -99
#define kStatusSuccess                  0 //请求成功
#define kStatusNetworkFailed            404


#define kUrlBase                    @"http://116.62.202.152/api/mouth/pat/index.php/"

#define kHtmlBase                   @"http://116.62.202.152/api/mouth/app-web/kq_pro/app"
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
#define kCityList                   @"main/cityList"//获取城市列表
#define kAppointList                @"apl/applyList" //我的预约列表
#define kAppointDetail              @"apl/applyInfo"//预约详情
#define kCancelAppoint              @"apl/cancelApply" //取消预约
#define kAccecptAppoint             @"apl/agreeDentist" //采纳医生建议
#define kCreateOrder                 @"order/createOrder"
//H5链接

#define AppendHTML(shortUrl)   [NSString stringWithFormat:@"%@%@?userKey=%@",kHtmlBase,shortUrl,[HWUserLogin currentUserLogin].userkey]

#define kBaiKe                     AppendHTML(@"/baike/baike-list.html")     //百科
#define kAnswer                      AppendHTML(@"/my/answer.html") //问答
#define kHistory                 AppendHTML(@"/my/history.html") //记录
#define kFamily               AppendHTML(@"/my/my-fml.html")//家庭

#define kLoginGainVertifyCode        @"" //获取验证码
#define kLoginApp                    @"" //登录
#define kDetectionCapturePhotos      @"chk/checkImageList" // 牙菌检测-已检测照片
#define kDetectionDeletePhoto        @"chk/delCheckImage" // 牙菌检测-删除图片
#define kDetectionResult             @"chk/finishUploadImg" // 牙菌斑检测--结果
#define kDetectionCreateCase         @"chk/newCheck" // 牙菌斑检测 - 创建一个Case
#define kDetectionUploadImage        @"chk/uploadCheckImage"// 牙菌斑检测 - 上传一张图片并分析
#define kDetectionUploadReports      @"chk/uploadReports"// 牙菌斑检测 - 上传诊断报告图片

#define kRecommandDoctor             @"chk/dencitsQuery" // 牙菌斑检测 -推荐附近的医生
#define kRDoctorDetail               @"chk/dentistInfo" // 牙菌斑检测 -医生详情
#define kRDoctorOrder                @"apl/applyDentist"// 牙菌斑检测 - 预约

#define kCaseList                    @"fam/loadCheckList" //病例列表
#define kCaseDetail                  @"fam/checkDetail" //病例详情
#define kFamilyMembers               @"fam/loadMyFamily" //家庭成员列表
#define kPayCallBack                 @"order/orderCheck"//支付回调

#define kPersonCenterInfo            @"acc/getUserInfo"// 获取用户信息
#define kPersonCenterLogout          @"acc/logout" // 退出登录
#endif



