//
//  DFModelBase.h
//  deepfinity
//
//  Created by Hamidreza Vakilian on 12/24/1396 AP.
//  Copyright © 1396 nizek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "_modelbase.h"
/**
 All subclasses which want to work with +acquireWithUID:forceCreateWithModel: must implement -initWithModel:
 otherwise they have to implement their own acquire methods + their own initializers and then they are responsible for storing the instances in DFModelBase.modelsTable
 */
@interface MyModelBase : _modelbase

/**
 checks the table if we have any record by this UID.
 
 @param id UID for the model
 @return If found returns it otherwise return nil.
 */
+(instancetype)acquireWithID:(NSString*)id;

/**
 this method generates the UID based on model[@"id"] and returns if it found a match. otherwise based on the forceCreate it will create the model (if it's not null) or otherwise it returns nil.
 
 @param model json/other types to look for it's counterpart model in the map table
 @param forceCreate determines if the method should create and return the model anyway.
 @return the model or nil
 */
+(instancetype)acquireWithModel:(id)model forceCreate:(BOOL)forceCreate;

/**
 same as acquireWithModel:forceCreate: but accepts a block which is called if a match on table is found, allowing you to update the model.
 
 @param model json/other types to look for it's counterpart model in the map table
 @param forceCreate determines if the method should create and return the model anyway.
 @return the model or nil
 */
+(instancetype)acquireWithModel:(id)model forceCreate:(BOOL)forceCreate update:(void (^_Nullable)(id match, id model))updateCB;

/**
 checks the table if we have any record with this UID, if so it returns it otherwise if model is not null it creates the model and returns and otherwise it returns nil.
 
 @param uid UID for the model
 @param model json/other types to create the model from
 @return nil or the model
 */
+(instancetype)acquireWithUID:(NSString*)uid forceCreateWithModel:(id)model;

/**
 same as acquireWithUID:forceCreateWithModel: but accepts a block which is called if a match on table is found, allowing you to update the model.
 
 @param uid UID for the model
 @param model json/other types to create the model from
 @return nil or the model
 */
+(instancetype)acquireWithUID:(NSString*)uid forceCreateWithModel:(id)model update:(void (^_Nullable)(id match, id model))updateCB;
/**
 convenient method for acquiring multiple Models from their respective JSONs.
 
 @param models array of NSDictionary representing each model
 @param force should the acquision be forced or not
 @return the array of acquired models
 */
+(NSArray<__kindof MyModelBase*>*)acquireMultipleWithModels:(NSArray<id>*)models forceCreate:(BOOL)force;

/**
 same as acquireMultipleWithModels:models: but accepts a block which is called if a match on table is found, allowing you to update the model.
 
 @param models array of NSDictionary representing each model
 @param force should the acquision be forced or not
 @return the array of acquired models
 */
+(NSArray<__kindof MyModelBase*>*)acquireMultipleWithModels:(NSArray<id>*)models forceCreate:(BOOL)force  update:(void (^_Nullable)(id match, id model))updateCB;
/**
 Returns all models for the caller class. if called on MyModelBase it returns all the models from all classes. if called on a specific class, it returns only the models from that class.
 
 @return array of models
 */
@property (nonatomic, readonly, class) NSArray* allModels;


/**
 If called on MyModelBase it will remove all the cached models. if you call it on a specific subclass of MyModelBase it will only purge the models from that calss.
 */
+(void)purgeModels;
@end
