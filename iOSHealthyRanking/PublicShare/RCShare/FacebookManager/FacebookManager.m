//
//  FacebookManager.m
//  iOSHealthyRanking
//
//  Created by TCH on 15/5/15.
//  Copyright (c) 2015年 com.rcplatform. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager

static FacebookManager *facebookManager = nil;

+ (FacebookManager *)shareManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        facebookManager = [[FacebookManager alloc]init];
    });
    return facebookManager;
}

-(void)fbResync
{
    ACAccountStore *accountStore;
    ACAccountType *accountTypeFB;
    if ((accountStore = [[ACAccountStore alloc] init]) && (accountTypeFB = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook] ) ){
        
        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
        id account;
        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
            
            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
                //we don't actually need to inspect renewResult or error.
                if (error){
                    
                }
            }];
        }
    }
}

-(void)loginSuccess:(void(^)())success andFailed:(void (^)(NSError *error))failure
{
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here
        
        NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions",@"user_friends", nil];
        [FBSession openActiveSessionWithPublishPermissions:permissions
        defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session,FBSessionState state,NSError *error) {
            NSLog(@"aaaaa");
            
            switch (state) {
                case FBSessionStateClosedLoginFailed:
                    //TODO handle here.
                    _isLogined = NO;
                    failure(error);
                    break;
                default:
                    _isLogined = YES;
                    success();
                    break;
            }
        }];
        
        
//        [FBSession.activeSession openWithCompletionHandler:^(
//                                                             FBSession *session,
//                                                             FBSessionState state,
//                                                             NSError *error) {
//            NSLog(@"aaaaa");
//            
//            switch (state) {
//                case FBSessionStateClosedLoginFailed:
//                    //TODO handle here.
//                    _isLogined = NO;
//                    failure(error);
//                    break;
//                default:
//                    _isLogined = YES;
//                    success();
//                    break;
//            }
//        }];
    }
    else
    {
        _isLogined = YES;
        success();
    }
}

-(void)logOut
{
    if (_isLogined){
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

-(void)getUserInfoSuccess:(void(^)(NSDictionary *userInfo))success andFailed:(void (^)(NSError *error))failure
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection,
       NSDictionary<FBGraphUser> *user,
       NSError *error) {
         if (!error) {
             success(user);
         }
         else{
             failure(error);
         }
     }];
}

-(void)loadfriendsSuccess:(void(^)(NSArray*))success andFailed:(void (^)(NSError *error))failure
{
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        if (!error) {
            NSArray* friends = [result objectForKey:@"data"];
            success(friends);
//            NSLog(@"%@ Found: %ld friends",friends, friends.count);
//            for (NSDictionary<FBGraphUser>* friend_ in friends) {
//                NSLog(@"I have a friend named %@ with id %@", friend_.name, friend_.id);
//            }
        }
        else
        {
            failure(error);
        }
    }];
}

-(void)getCoverGraphPathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure
{
    [FBRequestConnection startWithGraphPath:@"me?fields=cover"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  success(result);
                              } else {
                                  failure(error);
                              }
                          }];
}

-(void)getHeadPicturePathSuccess:(void(^)(NSDictionary *dic))success andFailed:(void (^)(NSError *error))failure
{
    [FBRequestConnection startWithGraphPath:@"me?fields=picture"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  success(result);
                              } else {
                                  failure(error);
                              }
                          }];
}

//void _share(const char * name,const char * caption, const char * desc, const char * link, const char * picture)
//{
//    NSMutableDictionary * postParams =
//    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//     [NSString stringWithUTF8String:link], @"link",
//     [NSString stringWithUTF8String:picture], @"picture",
//     [NSString stringWithUTF8String:name], @"name",
//     [NSString stringWithUTF8String:caption], @"caption",
//     [NSString stringWithUTF8String:desc], @"description",
//     nil];
//    [FBRequestConnection
//     startWithGraphPath:@"me/feed"
//     parameters:postParams
//     HTTPMethod:@"POST"
//     completionHandler:^(FBRequestConnection *connection,
//                         id result,
//                         NSError *error) {
//         NSString *alertText;
//         if (error) {
//             alertText = [NSString stringWithFormat:
//                          @"error: domain = %@, code = %d",
//                          error.domain, error.code];
//         } else {
//             alertText = [NSString stringWithFormat:
//                          @"Posted action, id: %@",
//                          [result objectForKey:@"id"]];
//         }
//         // Show the result in an alert
//         [[[UIAlertView alloc] initWithTitle:@"Result"
//                                     message:alertText
//                                    delegate:nil
//                           cancelButtonTitle:@"OK!"
//                           otherButtonTitles:nil]
//          show];
//     }];
//}
//void FacebookProxyShare(const char * name,const char * caption, const char * desc, const char * link, const char * picture)
//{
//    if ([FBSession.activeSession.permissions
//         indexOfObject:@"publish_actions"] == NSNotFound) {
//        //No permissions found in session, ask for it
//        [FBSession.activeSession
//         reauthorizeWithPublishPermissions:
//         [NSArray arrayWithObject:@"publish_actions"]
//         defaultAudience:FBSessionDefaultAudienceFriends
//         completionHandler:^(FBSession *session, NSError *error) {
//             if (!error) {
//                 // If permissions granted, publish the story
//                 _share(name, caption, desc, link, picture);
//             }
//         }];
//    } else {
//        // If permissions present, publish the story
//        _share(name, caption, desc, link, picture);
//    }
//}

-(void)shareWithName:(NSString *)name caption:(NSString *)caption desc:(NSString *)desc link:(NSString *)link picture:(NSString *)picture
{
    NSMutableDictionary * postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     link, @"link",
     picture, @"picture",
     name, @"name",
     caption, @"caption",
     desc, @"description",
     nil];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"74B10FBCB7E8" ofType:@"jpg"];
//    NSMutableDictionary * postParams =
//    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
//     link, @"link",
//     path, @"picture",
//     name, @"name",
//     caption, @"caption",
//     desc, @"description",
//     nil];

    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         if (error) {
             NSLog(@"%@,%@",error,error.description);
             showLabelHUD(@"failed");
         }
         else
         {
             showLabelHUD(@"success");
         }
//         NSString *alertText;
//         if (error) {
//             alertText = [NSString stringWithFormat:
//                          @"error: domain = %@, code = %d",
//                          error.domain, error.code];
//         } else {
//             alertText = [NSString stringWithFormat:
//                          @"Posted action, id: %@",
//                          [result objectForKey:@"id"]];
//         }
//         // Show the result in an alert
//         [[[UIAlertView alloc] initWithTitle:@"Result"
//                                     message:alertText
//                                    delegate:nil
//                           cancelButtonTitle:@"OK!"
//                           otherButtonTitles:nil]
//          show];
     }];

}

-(void)shareToFacebookWithName:(NSString *)name caption:(NSString *)caption desc:(NSString *)desc link:(NSString *)link picture:(NSString *)picture
{
    if ([FBSession.activeSession.permissions
         indexOfObject:@"publish_actions"] == NSNotFound) {
        //No permissions found in session, ask for it
        [FBSession.activeSession
         reauthorizeWithPublishPermissions:
         [NSArray arrayWithObject:@"publish_actions"]
         defaultAudience:FBSessionDefaultAudienceFriends
         completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 // If permissions granted, publish the story
                 [self shareWithName:name caption:caption desc:desc link:link picture:picture];
             }
         }];
    } else {
        // If permissions present, publish the story
        [self shareWithName:name caption:caption desc:desc link:link picture:picture];
    }

}

@end
