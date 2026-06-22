# frozen_string_literal: true

Тогда(/^захожу на страницу "(.+?)"$/) do |url|
  visit url
  $logger.info("Страница #{url} открыта")
  sleep 1
end

Тогда(/^кликаю по кнопке "([^"]*)" в середине экрана$/) do |button_text|
  link_first = find(:xpath,"//a[@href='/ru/downloads/']")
  link_first.click
  $logger.info("Переход на страницу \"#{button_text}\" осуществлен")
  sleep 1
end

Тогда(/^скачиваю из блока "([^"]*)" последнюю версию "([^"]*)"$/) do |stable_release, ruby_version|
  link_first = find(:xpath, "//ul[2]/li[1]/ul/li[1]/a")
  link_first.click
  $logger.info("Последняя версия Ruby \"#{ruby_version}\" из блока \"#{stable_release}\" загружена")
end

Тогда(/^проверяю, что файл находится в нужной директории$/) do
  if !File.expand_path('features/tmp').nil?
    $logger.info("Файл находится по заявленному пути #{File.expand_path('features/tmp').last}")
  elsif !Dir.children(File.expand_path('features/tmp')).nil?
    $logger.info("Файл находится по заявленному пути #{Dir.children(File.expand_path('features/tmp')).last}")
  else $logger.error("Файл отсутствует по заявленному пути")
  end
end
 
Тогда(/^проверяю, что имя скачанного файла совпадает с именем файла-установщика, указанного на сайте$/) do
  link_first = find(:xpath,"//ul[2]/li[1]/ul/li[1]/a")
  link_href = link_first[:href]
  link_file_name = File.basename(link_href)
  if
  link_file_name+'.crdownload'==File.expand_path('features/tmp').last
  $logger.info("Файл находится в нужной директории")
  elsif
    link_file_name+'.crdownload'==Dir.children(File.expand_path('features/tmp')).last
    $logger.info("Файл находится в нужной директории")
  
  else
    $logger.error("Файл отсутствует в нужной директории")
  end
end

Тогда(/^я должен увидеть текст на странице "([^"]*)"$/) do |text_oleg|
  sleep 1
  $logger.info("#{text_oleg}")
end
