//
//  ssncrc64.h
//  ssn
//
//  Created by lingminjun on 14-3-18.
//  Copyright (c) 2014年 Alibaba(China)Technology Co.,Ltd. All rights reserved.
//

#ifndef __ssn__crc64_h
#define __ssn__crc64_h

#include <stdint.h>

#if defined(__cplusplus)
#define SSN_CRC_EXTERN extern "C"
#else
#define SSN_CRC_EXTERN extern
#endif

SSN_CRC_EXTERN uint64_t ssn_crc64(uint64_t crc, const unsigned char *s, uint64_t l);

#endif
