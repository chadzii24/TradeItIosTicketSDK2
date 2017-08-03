//
//  TradeItConnector.h
//  TradeItIosEmsApi
//
//  Created by Antonio Reyes on 1/12/16.
//  Copyright © 2016 TradeIt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TradeItTypeDefs.h"
#import "TradeItAuthenticationInfo.h"
#import "TradeItResult.h"
#import "TradeItAuthLinkResult.h"
#import "TradeItUpdateLinkResult.h"
#import "TradeItLinkedLogin.h"
#import "TradeItBroker.h"

/**
   Main class to manage the connection settings to the Trade It Execution Management System (EMS). And the account linking and storing of the userToken used for establishing the session
 */
@interface TradeItConnector : NSObject

/**
 *  The apiKey is generated by TradeIt and unique to your application and is required for all API requests
 */
// TODO: Enforce this to be Nonnull?
@property NSString * _Nonnull apiKey;

/**
 *  Environment to send the request to. Default value is TradeItEmsProductionEnv
 *  Tokens and API Keys are specific to environment
 */
@property TradeitEmsEnvironments environment;

/**
 *  API version to use.  Defaults to the latest.
 */
@property TradeItEmsApiVersion version;

- (nonnull id)initWithApiKey:(nonnull NSString *)apiKey
                 environment:(TradeitEmsEnvironments)environment
                     version:(TradeItEmsApiVersion)version;

/**
 *  Using a successful response from the linkBrokerWithAuthenticationInfo:andCompletionBlock: this method will save basic information to the user preferences, and a UUID pointed to the actual user token which will be stored in the keychain.
 */
- (TradeItLinkedLogin * _Nullable)saveToKeychainWithLink:(TradeItAuthLinkResult * _Nullable)link
                                              withBroker:(NSString * _Nullable)broker;

/**
 *  Same as above, but with a custom label. Useful if allowing users to link to more than one login per broker. The default, in the above method, is just the broker name.
 */
- (TradeItLinkedLogin * _Nullable)saveToKeychainWithLink:(TradeItAuthLinkResult * _Nullable)link
                                              withBroker:(NSString * _Nullable)broker
                                                andLabel:(NSString * _Nullable)label;

- (TradeItLinkedLogin * _Nullable)saveToKeychainWithUserId:(NSString * _Nullable)userId
                                              andUserToken:(NSString * _Nullable)userToken
                                                 andBroker:(NSString * _Nullable)broker
                                                  andLabel:(NSString * _Nullable)label;

/**
 *  Using a successful response from the updateUserToken:withAuthenticationInfo:andCompletionBlock: this method will update the keychain token for an already linked account.
 */
- (TradeItLinkedLogin * _Nullable)updateKeychainWithLink:(TradeItAuthLinkResult * _Nullable)link
                                              withBroker:(NSString * _Nullable)broker;

/**
 *  Retrieve a list of stored linkedLogins
 * @return an Array of TradeItLinkedLogin
 */
- (NSArray * _Nullable)getLinkedLogins;

- (void)deleteLocalLinkedLogin:(TradeItLinkedLogin * _Nonnull)login;

@end
