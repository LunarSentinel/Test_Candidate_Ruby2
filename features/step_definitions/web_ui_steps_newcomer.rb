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

Тогда(/^скачиваю последнюю версию Ruby$/) do 
  link_first = find(:xpath, "(//li[*[contains(text(), 'Стабильные релизы')]]//*[contains(text(),'Ruby')])[1]")#[:href]
  link_first.click
  $logger.info("Последняя версия Ruby загружена")
end

Тогда(/^проверяю есть ли в папке иная версия Ruby$/) do
  check = Dir.children(File.expand_path('features/tmp'))
  @folder_filled=''
  if !check.empty?
    $logger.info("Необходима очистка хранилища. В папке есть иная версия Ruby:#{check}")
    @folder_filled='Есть файлы'
  else 
    $logger.info('Хранилище не содержит иную версию Ruby. Можно спокойно скачивать последнюю версию.')
  end
end


Тогда(/^проверяю, что файл находится в нужной директории$/) do
  check = Dir.children(File.expand_path('features/tmp'))
  if !check.empty?
    $logger.info("Недавно скачанный файл находится в нужной директории")
  else 
    $logger.info('В директории нет файлов')
  end
end


Тогда(/^очищаю хранилище от файлов$/) do
  
  if !@folder_filled.empty?
    $logger.info("Приступаю к очистке хранилища")
    delete_path = File.expand_path('features/tmp')
    Dir.children(delete_path).each do |filename|
    full_path = File.join(delete_path, filename)
    if File.file?(full_path)
      File.delete(full_path) 
    end
  end
  else 
    $logger.info('Хранилище не содержит иную версию Ruby. Можно спокойно скачивать последнюю версию.')
  end
end
 
Тогда(/^проверяю, что имя скачанного файла совпадает с именем файла-установщика, указанного на сайте$/) do
  link_first = find(:xpath,"(//li[*[contains(text(), 'Стабильные релизы')]]//*[contains(text(),'Ruby')])[1]")
  link_href = link_first[:href]
  link_file_name = File.basename(link_href)
  directory_file=Dir.children(File.expand_path('features/tmp')).last
 if link_file_name+'.crdownload'==directory_file
    $logger.info("Имя файла на сайте:#{link_file_name+'.crdownload'}. Имя файла в директории:#{directory_file}")
  else
    $logger.error("Файл отсутствует в нужной директории")
  end
end
