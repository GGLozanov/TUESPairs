import unittest
from selenium import webdriver
import time


class RegisterLoginDelete(unittest.TestCase):
    
    def setUp(self):

        self.edit_personal_info_page = 'http://localhost:3000/edit_personal_info'
        self.home_page = 'http://localhost:3000/home'

        self.email = 'test123456@gmail.com'
        self.password = 'test123'
        self.username = 'testUsername'
        self.gpa = 5
        self.tags = ['ZB50yYbWJnB6uFgYY4lq', 'S5usffyIJZCUSJwQYMZE']

        self.expected_url_after_register = 'http://localhost:3000/account'
        self.expected_url_after_login = 'http://localhost:3000/home'
        self.expected_ulr_after_deletion = 'http://localhost:3000/sign'
        self.expected_ulr_after_sign_out = 'http://localhost:3000/sign'
        
        self.driver = webdriver.Chrome('C:\development\chromedriver\chromedriver.exe')
        self.driver.maximize_window()
        self.driver.get(self.home_page)
        
        time.sleep(3)


    def navigate_to_register(self):
        self.go_to_register_page_clickable = self.driver.find_element_by_class_name('inner-container')

        self.go_to_register_page_clickable.click()

        time.sleep(3)

    def complete_first_register_step(self):
        self.email_field = self.driver.find_element_by_name('email')
        self.password_field = self.driver.find_element_by_name('passwordOne')
        self.confirm_password_field = self.driver.find_element_by_name('passwordTwo')
        self.sign_up_button = self.driver.find_element_by_class_name('btn')

        self.email_field.clear()
        self.password_field.clear()
        self.confirm_password_field.clear()

        self.email_field.send_keys(self.email)
        self.password_field.send_keys(self.password)
        self.confirm_password_field.send_keys(self.password)

        self.sign_up_button.click()

        time.sleep(3)

    def complete_second_register_step(self):
        self.username_filed = self.driver.find_element_by_name('username')
        self.gpa_field = self.driver.find_element_by_name('GPA')
        self.tags_clickable = [self.driver.find_element_by_name(tag) for tag in self.tags]
        self.submit_button = self.driver.find_element_by_xpath("//*[contains(text(), 'Submit')]")
        
        self.username_filed.clear()
        self.gpa_field.clear()

        self.username_filed.send_keys(self.username)
        self.gpa_field.send_keys(str(self.gpa))


        for tag_clickable in self.tags_clickable:
            tag_clickable.click()
        self.submit_button.click()

        time.sleep(3)
    
    def complete_third_register_step(self):

        self.continue_button = self.driver.find_element_by_xpath("//*[contains(text(), 'Continue')]")

        self.continue_button.click()
        
        time.sleep(3)

    def fill_login_form(self):

        self.email_field = self.driver.find_element_by_name('email')
        self.password_field = self.driver.find_element_by_name('password')
        self.login_button = self.driver.find_element_by_class_name('btn')

        self.email_field.clear()
        self.password_field.clear()
        
        self.email_field.send_keys(self.email)
        self.password_field.send_keys(self.password)

        self.login_button.click()

        time.sleep(3)

    def test_00_register(self):
    
        self.navigate_to_register()
        self.complete_first_register_step()
        self.complete_second_register_step()
        self.complete_third_register_step()

        self.assertEqual(self.driver.current_url, self.expected_url_after_register)

    def test_01_login(self):
    
        self.fill_login_form()

        self.assertEqual(self.driver.current_url, self.expected_url_after_login)
    
    def test_02_signout(self):

        self.fill_login_form()

        self.sign_out_button = self.driver.find_element_by_xpath("//*[contains(text(), 'Sign Out')]")
        
        self.sign_out_button.click()

        time.sleep(3)

        self.assertEqual(self.driver.current_url, self.expected_ulr_after_sign_out)


    def test_03_delete(self):
    
        self.fill_login_form()
        
        self.driver.get(self.edit_personal_info_page)

        time.sleep(3)
        
        self.delete_button = self.driver.find_element_by_class_name('delete-profile')

        self.delete_button.click()

        time.sleep(3)

        self.confirm_deletion_button = self.driver.find_element_by_xpath("//*[@class='btn btn-outline-success']")

        self.confirm_deletion_button.click()

        time.sleep(3)

        self.assertEqual(self.driver.current_url, self.expected_ulr_after_deletion)

    
    
    def tearDown(self):

        self.driver.quit()


if __name__ == '__main__':
    unittest.TestLoader.sortTestMethodsUsing = None
    unittest.main()