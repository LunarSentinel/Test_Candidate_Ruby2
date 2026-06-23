# frozen_string_literal: true

Дано(/^получаю информацию о пользователях$/) do
  users_full_information = $rest_wrap.get('/users')

  $logger.info('Информация о пользователях получена')
  @scenario_data.users_full_info = users_full_information
end

Тогда(/^проверяю (наличие|отсутствие) логина (\w+) в списке пользователей$/) do |presence, login|
  search_login_in_list = true
  presence == 'отсутствие' ? search_login_in_list = !search_login_in_list : search_login_in_list

  logins_from_site = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  login_presents = logins_from_site.include?(login)

  if login_presents
    message = "Логин #{login} присутствует в списке пользователей"
    search_login_in_list ? $logger.info(message) : raise(message)
    $logger.info(login_presents)
  else
    message = "Логин #{login} отсутствует в списке пользователей"
    search_login_in_list ? raise(message) : $logger.info(message)
  end
end

Тогда(/^удаляю пользователя по логину (\w+)$/) do |login|

  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data.users_full_info,
                                                  user_login: login)
    user_id = @scenario_data.users_id[login]
    response = $rest_wrap.delete('/users/'+user_id.to_s)
    $logger.info(response.inspect)
  else
    $logger.info(response.inspect)
  end 
  
end


Тогда(/^изменяю у пользователя с логином (\w+[0-9]|[0-9]) имя на (\w+) фамилию на (\w+|\p{Cyrillic}+) пароль на (\w+) и значение поля active на (\-?\w+)$/) do |login, name, surname, password, active_input|
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

Тогда(/^добавляю пользователя с логином (\w+[0-9]|[0-9]) именем (\w+) фамилией (\w+) паролем (\w+) значением поля active (\-?\w+)$/) do |login, name, surname, password, active_input|
  response = $rest_wrap.post('/users', login: login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: active_input)
  $logger.info(response.inspect)
    
end

When(/^добавляю пользователя с параметрами:$/) do |data_table|
  user_data = data_table.raw
  
  login = user_data[0][1]
  name = user_data[1][1]
  surname = user_data[2][1]
  password = user_data[3][1]
  active_input = user_data[4][1]

  step "добавляю пользователя с логином #{login} именем #{name} фамилией #{surname} паролем #{password} значением поля active #{active_input}"
end

Тогда(/^нахожу пользователя с логином (\w+) в списке пользователей$/) do |login|
  step %(получаю информацию о пользователях)
  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end

  $logger.info("Найден пользователь #{login} с id:#{@scenario_data.users_id[login]}")
  $logger.info(@scenario_data.users_id[login].inspect)
end

