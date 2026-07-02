# frozen_string_literal: true

Дано(/^получаю информацию о пользователях$/) do
  users_full_information = $rest_wrap.get('/users')
  @scenario_data.users_full_info = users_full_information
end

Тогда(/^проверяю (наличие|отсутствие) логина "?([\w\d]+)"? в списке пользователей$/) do |presence, login|
  step %(получаю информацию о пользователях)
  search_login_in_list = true
  if presence == 'отсутствие'
    search_login_in_list = false
  end

  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)

  if login_presents
    message = "Логин #{login} присутствует в списке пользователей"
    search_login_in_list ? $logger.info(message) : raise(message)
  else
    message = "Логин #{login} отсутствует в списке пользователей"
    search_login_in_list ? raise(message) : $logger.info(message)
  end
end

Тогда(/^удаляю пользователя по логину "?([\w\d]+)"?$/) do |login|
  step %(получаю информацию о пользователях)
    $logger.info("Удаляю пользователя с логином #{login}")
    if @scenario_data.users_id[login].nil?
      begin
        @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data.users_full_info,
                                                    user_login: login)
        user_id = @scenario_data.users_id[login]
        response = $rest_wrap.delete('/users/'+user_id.to_s)
        $logger.info(response.inspect)
      rescue RuntimeError => e
        if e.message.include?("Логин #{login} пользователя отсутствует в списке пользователей")
          puts "Предупреждение: Пользователь #{login} не найден, удаление отменено."
        else
          raise e
        end
      end
    end 
end


Тогда(/^изменяю у пользователя с логином "?([\w\d+]+)"? имя на "?([\w\d]+)"? фамилию на "?([\w\d\p{Cyrillic}]+)"? пароль на "?([\w\d]+)"? и значение поля active на "?([\w\-?\d]+)"?$/) do |login, name, surname, password, active_input|
    if @scenario_data.users_id[login].nil?
      @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data.users_full_info,
                                                    user_login: login)
      user_id = @scenario_data.users_id[login]
      response = $rest_wrap.put('/users/'+user_id.to_s, login: login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: active_input)
      $logger.info(response.inspect)
    end
end
Тогда(/^добавляю пользователя с логином "?([\w\d]+)"? именем "?([\w\d]+)"? фамилией "?([\w\d]+)"? паролем "?([\w\d]+)"? значением поля active "?([\w\-?\d]+)"?$/) do |login, name, surname, password, active_input|
  step %(получаю информацию о пользователях)
  $logger.info("Добавляю пользователя с логином #{login}")
  response = $rest_wrap.post('/users', login: login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: active_input)

  $logger.info(response.inspect) 
end

Тогда(/^добавляю пользователя с случайным логином "?([\w\d]+)"? именем "?([\w\d]+)"? фамилией "?([\w\d]+)"? паролем "?([\w\d]+)"? значением поля active "?([\w\d]+)"?$/) do |random_login, name, surname, password, active_input|
  new_login = random_login + (find_max_user_number + 1).to_s
  $logger.info("Добавляю пользователя с логином #{new_login}")
  response = $rest_wrap.post('/users', login: new_login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: active_input)
  $logger.info(response.inspect)
end

Тогда(/^нахожу пользователя с логином "?([\w\d]+)"? в списке пользователей$/) do |login|
  step %(получаю информацию о пользователях)
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end
  $logger.info("Найден пользователь #{login} с id:#{@scenario_data.users_id[login]}")
end

Тогда(/^нахожу пользователя с случайным добавленным логином "?([\w\d]+)"? в прошлом шаге в списке пользователей$/) do |random_login|
  new_login = random_login + (find_max_user_number).to_s
  if @scenario_data.users_id[new_login].nil?
    @scenario_data.users_id[new_login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: new_login)
  end
  $logger.info("Найден пользователь #{new_login} с id:#{@scenario_data.users_id[new_login]}")
end

Тогда(/^проверяю изменения по логину "?([\w\d]+)"?$/) do |login|
   step %(получаю информацию о пользователях)
  if @scenario_data.users_id[login].nil?
    $logger.info("#{@scenario_data.users_id[login]}")
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end
  $logger.info("У пользователя #{login} новые данные: #{$rest_wrap.get('/users/'+@scenario_data.users_id[login].to_s)}")
end

Тогда (/^проверяю обработку несуществующего ID равного "?([\w\d]+)"?$/) do |id|
  @response = $rest_wrap.get('/users/'+id.to_s)
  if !@response.include?('status')
    $logger.info("Пользователь с ID:#{id} существует")
  else
    $logger.info("Пользователь с ID:#{id} не существует")
  end 
end

Тогда (/^получаю ошибку 404 для несуществующего ID равного "?([\w\d]+)"?$/) do |id|
  if @response.include?('status')
  expect(@response).to have_content('{"name" => "Not found", "message" => "Row with current id not found in database.", "status" => 404}')
  $logger.info("#{@response}")
  else
  $logger.info("Ошибка не получена, т.к. пользователь с ID:#{id} существует")
  end
end