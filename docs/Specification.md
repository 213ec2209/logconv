# FP16 to Log₂ Conversion Documentation

# Overview

# 

# A floating-point to logarithmic conversion unit is a fundamental arithmetic block used in log-domain computation, approximate arithmetic, and energy-efficient AI accelerators. Converting floating-point values into the logarithmic domain simplifies multiplication into addition, enabling faster and lower-power hardware implementations.

# 

# The module described in this document converts a 16-bit IEEE-754 half-precision (FP16) floating-point input into a signed fixed-point Q5.10 representation of log₂(x). The design uses a Mitchell-style approximation for the fractional logarithm to minimize hardware complexity while maintaining reasonable accuracy.

# 

# The conversion is fully combinational and suitable for synthesis in FPGA or ASIC flows.

# 

# Required Parameters

# 

# To understand the FP16 to log₂ conversion functionality, the following parameters are required:

# 

# FP16 input value (fp16\_in)

# 

# Exponent field

# 

# Mantissa field

# 

# Fixed-point logarithmic output (log\_out\_q5\_10)

# 

# Module Description

# 

# The FP16 to log₂ converter operates as follows:

# 

# The input floating-point value is decomposed into sign, exponent, and mantissa

# 

# The integer part of the logarithm is derived from the exponent

# 

# The fractional part is approximated using the mantissa

# 

# The final log₂(x) value is produced in Q5.10 fixed-point format

# 

# Special handling is provided for zero inputs

# 

# Input and Output Description

# Inputs

# 

# fp16\_in : 16-bit IEEE-754 half-precision floating-point input

# 

# Bit\[15] : Sign

# 

# Bit\[14:10] : Exponent

# 

# Bit\[9:0] : Mantissa

# 

# Outputs

# 

# log\_out\_q5\_10 : 16-bit signed fixed-point output in Q5.10 format

# Represents log₂(x)

# 

# Supported Number Formats

# FP16 Input Format

# 

# 1-bit sign

# 

# 5-bit exponent (bias = 15)

# 

# 10-bit mantissa

# 

# Q5.10 Output Format

# 

# 1 sign bit

# 

# 5 integer bits

# 

# 10 fractional bits

# 

# Numeric range:

# −32 ≤ log₂(x) < +31.999

# 

# Functionality

# 

# The module computes the logarithm using the identity:

# 

# log

# ⁡

# 2

# (

# 𝑥

# )

# =

# (

# 𝐸

# −

# 15

# )

# \+

# log

# ⁡

# 2

# (

# 1

# \+

# 𝑓

# )

# log

# 2

# &nbsp;	​

# 

# (x)=(E−15)+log

# 2

# &nbsp;	​

# 

# (1+f)

# 

# Where:

# 

# 𝐸

# E is the FP16 exponent

# 

# 𝑓

# f is the normalized mantissa

# 

# Logarithmic Conversion Operations

# Integer Logarithm

# 

# The integer portion is computed as:

# 

# int\_part

# =

# exp

# −

# 15

# int\_part=exp−15

# 

# Converted to Q5.10 format by left-shifting 10 bits

# 

# Fractional Logarithm Approximation

# 

# Mantissa is normalized to Q0.10 format:

# 

# 𝑓

# =

# mantissa

# 1024

# f=

# 1024

# mantissa

# &nbsp;	​

# 

# 

# Mitchell’s approximation is used:

# 

# log

# ⁡

# 2

# (

# 1

# \+

# 𝑓

# )

# ≈

# 𝑓

# log

# 2

# &nbsp;	​

# 

# (1+f)≈f

# 

# This avoids multipliers and lookup tables.

# 

# Final Logarithm Computation

# log

# ⁡

# 2

# (

# 𝑥

# )

# =

# int\_part\_q10

# \+

# frac\_log

# log

# 2

# &nbsp;	​

# 

# (x)=int\_part\_q10+frac\_log

# Special Case Handling

# Condition	Output

# Input = 0	−∞ represented as 16'h8000

# Normal positive FP16	Approximated log₂(x)

# Negative FP16	Not explicitly handled

# FP16 to Log₂ Conversion Algorithm

# Step 1 — Input Sampling

# 

# The FP16 input is sampled and decomposed into sign, exponent, and mantissa.

# 

# Step 2 — Zero Detection

# 

# If both exponent and mantissa are zero, the output is forced to negative infinity.

# 

# Step 3 — Integer Log Computation

# 

# The exponent bias is removed to compute the integer portion of log₂(x).

# 

# Step 4 — Fractional Log Approximation

# 

# The mantissa is normalized and directly used as an approximation for log₂(1 + f).

# 

# Step 5 — Result Formation

# 

# The integer and fractional components are summed to generate the final Q5.10 output.

# 

# Algorithm Representation

# if fp16\_in == 0:

# &nbsp;   log\_out = -INF

# else:

# &nbsp;   int\_part = exp - 15

# &nbsp;   frac\_part = mantissa / 1024

# &nbsp;   log\_out = (int\_part << 10) + frac\_part

# 

# Design Characteristics

# 

# Architecture: Fully combinational

# 

# Latency: Single-cycle

# 

# Multipliers: None

# 

# LUTs: None

# 

# Synthesizable: Yes

# 

# Approximation Method: Mitchell’s approximation

# 

# Accuracy and Limitations

# 

# Fractional log₂ is linearly approximated

# 

# Typical relative error: ~1–3%

# 

# Negative inputs are not handled

# 

# Subnormal FP16 values are treated as zero

# 

# FSM-Controlled Process

# 

# The module does not use a multi-state FSM.

# 

# No clock dependency

# 

# No internal state storage

# 

# Conversion completes in a single combinational pass

# 

# Working Examples

# Example 1 — Exact Power of Two

# Input:  fp16 = 1.0

# Output: log₂(1.0) = 0.0

# Q5.10 = 0x0000

# 

# Example 2 — Value Greater Than One

# Input:  fp16 = 2.0

# Exponent = 16

# log₂(2.0) = 1.0

# Q5.10 = 0x0400

# 

# Example 3 — Fractional Input

# Input:  fp16 ≈ 1.5

# log₂(1.5) ≈ 0.585

# Q5.10 ≈ 0x0258

# 

# Example 4 — Zero Input

# Input:  fp16 = 0

# Output: -INF

# Q5.10 = 0x8000

# 

# Summary

# 

# The FP16 to log₂ conversion module provides a compact, fast, and hardware-efficient solution for transforming floating-point values into the logarithmic domain. By leveraging Mitchell’s approximation and fixed-point arithmetic, the design avoids expensive hardware components while remaining suitable for AI accelerators, log-domain multipliers, and low-power DSP systems.

