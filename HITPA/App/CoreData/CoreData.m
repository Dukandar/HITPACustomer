//
//  CoreData.m
//  HITPA
//
//  Created by Bhaskar C M on 12/21/15.
//  Copyright © 2015 Bathi Babu. All rights reserved.
//

#import "CoreData.h"
#import "MyPolicy.h"
#import "Hospital.h"
#import "UserManager.h"
#import "QuickConnectDetails.h"
#import "BranchLocator.h"

@implementation CoreData

#pragma mark -
+ (CoreData *)shareData
{
    static CoreData *_shareData = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _shareData = [[CoreData alloc]init];
        
    });
    
    return _shareData;
    
}

#pragma mark - init
-(instancetype)init
{
    
    self = [super init];
    
    if(self) {
        
        
    }
    
    return self;
    
}

#pragma mark - managedObjectContext

- (NSManagedObjectContext *)managedObjectContext
{
    
    NSManagedObjectContext *context=nil;
    id delegate=[[UIApplication sharedApplication] delegate];
    if([delegate performSelector:@selector(managedObjectContext)]){
        context=[delegate managedObjectContext];
    }
    return context;
    
}


#pragma mark - MyPolicy

-(BOOL)deletePolicyDetails{
    NSManagedObjectContext *context=[self managedObjectContext];
    MyPolicy *policyDetails = (MyPolicy *)[NSEntityDescription insertNewObjectForEntityForName:@"MyPolicy" inManagedObjectContext:context];
    NSMutableDictionary *dictionary = policyDetails.myPolicyDetails;
    for (NSManagedObject *managedObject in dictionary) {
        [context deleteObject:managedObject];
    }
    NSError *error=nil;
    if(![context save:&error]){
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return false;
    }
    return true;
}

- (void)setMyPolicyDetailsWithResponse:(NSDictionary *)response
{
    [self deletePolicyDetails];
    NSManagedObjectContext *context=[self managedObjectContext];
    
    MyPolicy *policyDetails = (MyPolicy *)[NSEntityDescription insertNewObjectForEntityForName:@"MyPolicy" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:response forKey:[NSString stringWithFormat:@"PolicyDetail%@", [[UserManager sharedUserManager] userName]]];
    
    [policyDetails setMyPolicyDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}


- (NSDictionary *)getPolicyDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"MyPolicy"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (MyPolicy *obj in contextarray) {
        
        NSDictionary *array = [obj.myPolicyDetails valueForKey:[NSString stringWithFormat:@"PolicyDetail%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark - MyPolicy History

- (void)setMyPolicyHistoryDetailsWithResponse:(NSDictionary *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    MyPolicy *policyDetails = (MyPolicy *)[NSEntityDescription insertNewObjectForEntityForName:@"MyPolicy" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:response forKey:[NSString stringWithFormat:@"PolicyHistoryDetail%@", [[UserManager sharedUserManager] userName]]];
    
    [policyDetails setMyPolicyDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}


- (NSDictionary *)getPolicyHistoryDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"MyPolicy"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (MyPolicy *obj in contextarray) {
        
        NSDictionary *array = [obj.myPolicyDetails valueForKey:[NSString stringWithFormat:@"PolicyHistoryDetail%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark- Mcard

- (void)setMcardDetailsWithResponse:(NSDictionary *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    MyPolicy *policyDetails =  (MyPolicy *)[NSEntityDescription insertNewObjectForEntityForName:@"MyPolicy" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[response valueForKey:@"response"] forKey:[NSString stringWithFormat:@"McardDetails%@", [[UserManager sharedUserManager] userName]]];
    
    [policyDetails setMyPolicyDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}

- (NSDictionary *)getMcardDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"MyPolicy"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (MyPolicy *obj in contextarray) {
        
        NSDictionary *array = [obj.myPolicyDetails valueForKey:[NSString stringWithFormat:@"McardDetails%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}


#pragma mark - HospitalDetails

- (void)setNearMeHospitalDetailsWithResponse:(NSDictionary *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    Hospital *hospitalDetails = (Hospital *)[NSEntityDescription insertNewObjectForEntityForName:@"Hospital" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[response valueForKey:@"response"] forKey:[NSString stringWithFormat:@"NearMeHospitalDetails%@", [[UserManager sharedUserManager] userName]]];
    
    [hospitalDetails setHospitalDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}


- (NSDictionary *)getNearMeHospitalDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"Hospital"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (Hospital *obj in contextarray) {
        
        NSDictionary *array = [obj.hospitalDetails valueForKey:[NSString stringWithFormat:@"NearMeHospitalDetails%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark- AllHospital

- (void)setAllHospitalDetailsWithResponse:(NSDictionary *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    Hospital *hospitalDetails =  (Hospital *)[NSEntityDescription insertNewObjectForEntityForName:@"Hospital" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:[response valueForKey:@"response"] forKey:[NSString stringWithFormat:@"AllHospitalDetails%@", [[UserManager sharedUserManager] userName]]];
    
    [hospitalDetails setHospitalDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}

- (NSDictionary *)getAllHospitalDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"Hospital"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (Hospital *obj in contextarray) {
        
        NSDictionary *array = [obj.hospitalDetails valueForKey:[NSString stringWithFormat:@"AllHospitalDetails%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark- QuickConnect

- (void)setQuickConnectDetailsWithResponse:(NSDictionary *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    QuickConnectDetails *quickConnectDetails =  (QuickConnectDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"QuickConnect" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:response forKey:[NSString stringWithFormat:@"QuickConnectDetails%@", [[UserManager sharedUserManager] userName]]];
    
    [quickConnectDetails setQuickConnectDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}

- (NSDictionary *)getQuickConnectDetail
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    NSFetchRequest *req=[[NSFetchRequest alloc] initWithEntityName:@"QuickConnect"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (QuickConnectDetails *obj in contextarray) {
        
        NSDictionary *array = [obj.quickConnectDetails valueForKey:[NSString stringWithFormat:@"QuickConnectDetails%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}

#pragma mark- BranchLocator

- (void)setBranchLocationsDetailsWithResponse:(NSArray *)response
{
    
    NSManagedObjectContext *context=[self managedObjectContext];
    
    BranchLocator *branchLocationsDetails =  (BranchLocator *)[NSEntityDescription insertNewObjectForEntityForName:@"BranchLocator" inManagedObjectContext:context];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:response forKey:[NSString stringWithFormat:@"BranchLocatorDetails%@", [[UserManager sharedUserManager] userName]]];
    
    [branchLocationsDetails setBranchDetails:dictionary];
    
    NSError *error=nil;
    if(![context save:&error])
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    
    
}

- (NSArray *)getBranchLocationsDetails
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"BranchLocator"];
    NSArray *contextarray  =[context executeFetchRequest:req error:nil];
    
    for (BranchLocator *obj in contextarray) {
        
        NSArray *array = [obj.branchDetails valueForKey:[NSString stringWithFormat:@"BranchLocatorDetails%@",[[UserManager sharedUserManager] userName]]];
        
        if(array !=nil && [array isKindOfClass:[array class]]){
            
            return array;
            
        }
        
    }
    
    return nil;
    
}


@end
