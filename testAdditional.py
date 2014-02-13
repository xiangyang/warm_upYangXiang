"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib

'''Test 1: test with expected fail parameters for add user fail due to bad password'''
    
class TestBadPasswordAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        self.assertDictEqual(expected, respData)

    def testPassAdd1(self):
        p = ""
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : p} )
        self.assertResponse(respData)

    def testPassAdd2(self):
        p = ""
        for x in range(129):
            p += "o"
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : 'user1', 'password' : p} )
        self.assertResponse(respData)

'''Test 2: test with expected fail parameters for add user fail due to bad username'''
    
class TestBadUsernameAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData,  errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        self.assertDictEqual(expected, respData)

    def testUserAdd1(self):
        u = ""
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'pass'} )
        self.assertResponse(respData)

    def testUserAdd2(self):
        u = ""
        for x in range(129):
            u += "o"
        respData = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'pass'} )
        self.assertResponse(respData)

'''Test 3: test with expected fail parameters for add user fail due to existing user'''
    
class TestExistingUsernameAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData,  errCode = testLib.RestTestCase.ERR_USER_EXISTS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        self.assertDictEqual(expected, respData)

    def testUserAdd(self):
        u = "supaUniq"
        respData1 = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'pass'} )
        respData2 = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'pass'} )
        self.assertResponse(respData2)

'''Test 4: test with expected fail parameters for login user'''
    
class TestFailLoginUser(testLib.RestTestCase):
    """Test login users"""
    def assertResponse(self, respData,  errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        self.assertDictEqual(expected, respData)

    def testLogin(self):
        u = "Bill Gates"
        respData1 = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'pass'} )
        respData2 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'pass1'} )
        self.assertResponse(respData2)



'''Test 5: test with expected success of login user'''
    
class TestLoginUser(testLib.RestTestCase):
    """Test login users"""
    def assertResponse(self, respData, count = 2, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLogin(self):
        u = "Steve Jobs"
        respData1 = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'password'} )
        respData2 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'password'} )
        self.assertResponse(respData2, count = 2)



'''Test 6: make sure count is adding correctly with multiple calls'''
    
class TestCount(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 4, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
        u = "Bobo"
        #counter should be 1
        respData1 = self.makeRequest("/users/add", method="POST", data = { 'user' : u, 'password' : 'password'} )
        #counter should be 2
        respData2 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'password'} )
         #counter should stay at 2 due to bad login
        respData3 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'password1'} )
         #counter should be 3
        respData4 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'password'} )
        #counter should be 4
        respData5 = self.makeRequest("/users/login", method="POST", data = { 'user' : u, 'password' : 'password'} )

        self.assertResponse(respData5, count = 4)






