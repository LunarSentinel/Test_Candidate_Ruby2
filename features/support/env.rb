# frozen_string_literal: true

require 'rest-client'
require 'active_support/all'
require_relative 'helpers/rest_wrapper'
require_relative 'helpers/logger'
require 'capybara/cucumber'
require 'selenium-webdriver'
require_relative 'helpers/class_extentions'

ENV['DISPLAY'] = ':0'
ENV['MOZ_ENABLE_WAYLAND'] = '0'

def browser_setup(browser = 'firefox')
  case browser
  when 'chrome'
    Capybara.register_driver :chrome do |app|
      executable_path =File.expand_path('configuration/chromedriver', Dir.pwd)
      service = Selenium::WebDriver::Service.chrome(path: executable_path)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_preference('profile.default_content_settings.popups', 0)
      options.add_preference('plugins.always_open_pdf_externally', true)
      options.add_preference('download.prompt_for_download', false)
      download_path = File.expand_path('features/tmp')
      options.add_preference(:download, 
      prompt_for_download: false, 
      default_directory: download_path)
      Capybara::Selenium::Driver.new(app, browser: :chrome, service:service, options: options)

    end
    Capybara.default_driver = :chrome
    Capybara.page.driver.browser.manage.window.maximize
    Capybara.default_selector = :xpath
    Capybara.default_max_wait_time = 15
  else
    
    Capybara.register_driver :firefox_driver do |app|
      executable_path = File.expand_path('configuration/geckodriver', Dir.pwd)
      service = Selenium::WebDriver::Service.firefox(path: executable_path)
      options = Selenium::WebDriver::Firefox::Options.new
      options.binary = '/usr/bin/firefox'

     # options.add_argument('-headless')
      options.add_argument('--no-sandbox')
      options.add_argument('--disable-dev-shm-usage')

      options.add_preference('browser.download.folderList', 2)
      options.add_preference('browser.download.dir', File.expand_path('features/tmp'))
      options.add_preference('browser.helperApps.neverAsk.saveToDisk', 'application/octet-stream, text/xml')
      options.add_preference('pdfjs.disabled', true)
      Capybara::Selenium::Driver.new(app, browser: :firefox, service: service, options: options)
    end
    Capybara.default_driver = :firefox_driver
  end
end
browser_setup('firefox')

configuration = YAML.load_file 'configuration/default.yml'
$rest_wrap = RestWrapper.new url: 'https://testing4qa.ediweb.ru/api',
                             **configuration[:credentials]
logger_initialize
