# 238. Product of Array Except Self

# Given an integer array nums, return an array answer such that answer[i] is equal to the product of all the elements of nums except nums[i].

# The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.

# You must write an algorithm that runs in O(n) time and without using the division operation.

 

# Example 1:

# Input: nums = [1,2,3,4]
# Output: [24,12,8,6]
# Example 2:

# Input: nums = [-1,1,0,-3,3]
# Output: [0,0,9,0,0]
 

# Constraints:

# 2 <= nums.length <= 105
# -30 <= nums[i] <= 30
# The input is generated such that answer[i] is guaranteed to fit in a 32-bit integer.
 

# Follow up: Can you solve the problem in O(1) extra space complexity?
#  (The output array does not count as extra space for space complexity analysis.)


# Solution 1 using built in function accumulate
import itertools, operator
nums = [1,2,3,4]
class Solution(object):
    def productExceptSelf(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        pre, suf, n = list(itertools.accumulate(nums, operator.mul)), list(itertools.accumulate(nums[::-1], operator.mul))[::-1], len(nums)
        return [(pre[i-1] if i else 1) * (suf[i+1] if i+1 < n else 1) for i in range(n)]
solution = Solution()
result = solution.productExceptSelf(nums)
print(result)


# In Python, itertools.accumulate() is a function that returns accumulated sums or results of a binary function.

# Basic usage:
# import itertools

# nums = [1, 2, 3, 4]

# result = itertools.accumulate(nums)

# print(list(result))


# Output:

# [1, 3, 6, 10]


# 👉 It adds up numbers step by step:

# 1

# 1+2 = 3

# 3+3 = 6

# 6+4 = 10

# Using with other functions

# You can also pass a function like max, min, or even operator.mul for multiplication.

# import itertools, operator

# nums = [1, 2, 3, 4]

# # Running multiplication
# result = itertools.accumulate(nums, operator.mul)
# print(list(result))


# Output:

# [1, 2, 6, 24]


# Here it multiplies step by step:
# 1 → 1*2=2 → 2*3=6 → 6*4=24

# ✅ In short: accumulate() keeps track of running totals (or running results of any operation).


# Solution 2 Without built in function using loops
nums = [1, 2, 3, 4]

class Solution(object):
    def productExceptSelf(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        n = len(nums)
        pre = [1] * n   # prefix products
        suf = [1] * n   # suffix products
        
        # Build prefix products
        for i in range(1, n):
            pre[i] = pre[i-1] * nums[i-1]
        
        # Build suffix products
        for i in range(n-2, -1, -1):
            suf[i] = suf[i+1] * nums[i+1]
        
        # Final result = prefix[i] * suffix[i]
        return [pre[i] * suf[i] for i in range(n)]

solution = Solution()
result = solution.productExceptSelf(nums)
print(result)



# Theoretical Explanation
# We are required to solve this problem without using the division operator. 
# We can do this by calculating two arrays pre and suf where pre[i] contains product of all nums[j] such that j <= i, 
# and suf[i] contains product of all nums[j] such that j >= i.

# Finally, the resulting array ans can be calculated as 
# ans[i] = pre[i-1] * suf[i+1] which is product of all elements with index less than i multiplied by product of all elements with index greater than i. 
# This is essentially equal to product of array except self at each index.
