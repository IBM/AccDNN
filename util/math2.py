#!/usr/bin/env python

def gcd(m, n):
    while n:
        m, n = n, m % n
    return m

def lcm(m, n):
    return m * n / gcd(m, n)

def is_power(n):
    return ((n & (n - 1)) == 0) and n != 0

if __name__ == '__main__':
    print lcm(512, 3)
    print '16:', is_power(16)
    print '4:', is_power(4)
    print '2:', is_power(2)
    print '5:', is_power(5)
    print '1:', is_power(1)
    
