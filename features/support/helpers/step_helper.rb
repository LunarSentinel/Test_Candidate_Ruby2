# frozen_string_literal: true

def find_user_id(users_information:, user_login:)
  users_id = []
  users_information.each do |user|
    next unless user['login'] == user_login

    users_id << user['id']
  end
  users_id.uniq!

  if users_id.size > 1
    raise "Логин пользователя неуникален! Найдено пользователей с аналогичным логином: #{users_id.size}, id: #{users_id.inspect}"
  elsif users_id.size < 1
    raise "Логин пользователя отсутствует в списке пользователей."
  end
  users_id.first
end

def find_max_user_number()
  users_full_information = $rest_wrap.get('/users')
  @scenario_data.users_full_info = users_full_information
  get_logins = @scenario_data.users_full_info.map { |f| f.try(:[], 'login') }
  name_filter =get_logins.grep(/QA_Micro_Test_Active_\w+/)
  number_filter = name_filter.map {|str| str[/\d+/]}
  next_number_login = (number_filter.compact.map(&:to_i).max).to_i
end