// Objective-C API for talking to bulletproofs Go package.
//   gobind -lang=objc bulletproofs
//
// File is generated by gobind. Do not edit.

#ifndef __Bulletproofs_H__
#define __Bulletproofs_H__

@import Foundation;
#include "ref.h"
#include "Universe.objc.h"


FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbDealerGenFinProof(long veclength, long m, NSString* _Nullable othersharesStr, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbDealerGenx(long veclength, long m, NSString* _Nullable T1T2ComStr, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbDealerGenyz(long veclength, long m, NSString* _Nullable ASComStr);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbProverGenOtherShare(long veclength, long m, NSData* _Nullable ppBytes, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbProverGenT1T2(long veclength, long m, NSData* _Nullable ppBytes, NSData* _Nullable mpcrpBytes);

/**
 * multi party Arbitrary Range Proof
 */
FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbProverGenVAS(long veclength, long m, long id_, long min, long max, NSString* _Nullable val);

FOUNDATION_EXPORT BOOL BulletproofsArbVerifierVerifyProof(long veclength, long m, NSData* _Nullable mpcrpBytes);

/**
 * one to one: single or multi arbitrary range proof
 */
FOUNDATION_EXPORT NSData* _Nullable BulletproofsArbitraryRPProve(long veclength, long m, long min, long max, NSString* _Nullable vals);

FOUNDATION_EXPORT BOOL BulletproofsArbitraryRPVerify(long veclength, long m, NSData* _Nullable proofJSONasBytes);

/**
 * one to one: single or multi stardand range proof
 */
FOUNDATION_EXPORT NSData* _Nullable BulletproofsStardandRPProve(long veclength, long m, NSString* _Nullable vals);

FOUNDATION_EXPORT BOOL BulletproofsStardandRPVerify(long veclength, long m, NSData* _Nullable proofJSONasBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdDealerGenFinProof(long veclength, long m, NSString* _Nullable othersharesStr, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdDealerGenx(long veclength, long m, NSString* _Nullable T1T2ComStr, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdDealerGenyz(long veclength, long m, NSString* _Nullable ASComStr);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdProverGenOtherShare(long veclength, long m, NSData* _Nullable ppBytes, NSData* _Nullable mpcrpBytes);

FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdProverGenT1T2(long veclength, long m, NSData* _Nullable ppBytes, NSData* _Nullable mpcrpBytes);

/**
 * multi party Stardand Range Proof
 */
FOUNDATION_EXPORT NSData* _Nullable BulletproofsStdProverGenVAS(long veclength, long m, long id_, NSString* _Nullable val);

FOUNDATION_EXPORT BOOL BulletproofsStdVerifierVerifyProof(long veclength, long m, NSData* _Nullable mpcrpBytes);

#endif
