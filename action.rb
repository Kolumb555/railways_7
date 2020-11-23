class Action
  
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def run #вывод меню и запрос действия

    loop do
      puts "\n Для выбора необходимого действия введите, пожалуйста, соответствующую цифру:

      1 - Создать станцию
      2 - Создать поезд
      3 - Создать маршрут и управлять станциями в нем (добавлять, удалять)
      4 - Назначить маршрут поезду
      5 - Добавить вагоны к поезду
      6 - Отцепить вагоны от поезда
      7 - Перемещать поезд по маршруту вперед и назад
      8 - Просмотреть список станций и список поездов на станциях
      0 - Выход из программы"

      choice = gets.to_i

      case choice
      when 1 #Создавать станции
        create_stations
      when 2 #Создавать поезда
        create_train
      when 3 #Создавать маршруты и управлять станциями в нем (добавлять, удалять)
        create_n_change_routes
      when 4 #Назначать маршрут поезду
        assign_route_to_train
      when 5 #Добавлять вагоны к поезду
        add_cars
      when 6 #Отцеплять вагоны от поезда
        delete_cars
      when 7 #Перемещать поезд по маршруту вперед и назад
        move_train
      when 8 #Просматривать список станций и список поездов на станции
        print_stations_n_trains
      when 9 #test
        puts "CargoTrain.instances #{CargoTrain.instances}"
        puts "PassengerTrain.instances #{PassengerTrain.instances}"
        puts "Route.instances #{Route.instances}"
        puts "Station.instances #{Station.instances}"
        
      when 0
        break
      end
    end
  end

  def create_stations
    begin
      puts 'Введите название станции'
      name = gets.chomp

      if @stations.count { |s| s.name.match(name) } == 0
        @stations << Station.new(name)
        puts "\n Станция #{name} добавлена"
      else
        puts "\n Такая станция уже существует"
      end
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def trains?
    if @trains.size == 0
      puts 'Отсутствует информация о поездах'
    end
  end

  def routes?
    if @routes.size == 0
      puts 'Отсутствует информация о маршрутах'
    end
  end

  def stations?
    if @stations.size == 0
      puts 'Отсутствует информация о станциях. Вначале необходимо добавить станции'
    end
  end

  def request_for_train_number #выводит список поездов и запрашивает номер
    puts 'Выберите порядковый номер поезда'
    @trains.each_with_index do |train, i|
      puts "#{i + 1}. #{train.number}"
    end
  end

  def create_train

    type = nil #тип поезда

    while type != 1 && type != 2
      puts 'Выберите тип поезда: 1 - пассажирский, 2 - грузовой'
      type = gets.to_i
    end

    begin
      puts 'Введите номер поезда'
      number = gets.chomp
    
      if type == 1
        @trains << PassengerTrain.new(number)
        puts "Создан пассажирский поезд номер #{number}"
      elsif type == 2
        @trains << CargoTrain.new(number)
        puts "Создан грузовой поезд номер #{number}"      
      end

    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def request_for_route_number #выводит список маршрутов и запрашивает выбор
    puts 'Выберите порядковый номер маршрута' 
    @routes.each_with_index do |route, i|
      puts "#{i + 1}. #{route.route_stations[0].name} - #{route.route_stations[-1].name}"
    end
  end

  def request_for_station_number #выводит список станций и запрашивает номер
    puts 'Выберите порядковый номер станции для добавления в маршрут. Для создания маршрута необходимо добавить как минимум 2 станции.'
    @stations.each_with_index do |station, i|
      puts "#{i + 1}. #{station.name}"
    end
  end

  def trains_number_with_routes_arr #возвращает массив номеров поездов с присвоенными маршрутами
    trains_with_routes = []
    @trains.each_with_index do |train, i|
      if train.route
        trains_with_routes << i
      end
    end
    trains_with_routes
  end

  def trains_with_routes #выводит список поездов с присвоенными маршрутами и запрашивает номер поезда
    puts 'Выберите порядковый номер поезда'
    @trains.each_with_index do |train, i|
      if train.route
        puts "#{i + 1}. #{train.number} #{train.route.route_stations[1, -1]}"
      end
    end
  end

  def is_included?(array, number)
    (1..array.size).include?(number)
  end

  def assign_route_to_train
    trains?
    routes?
  
    if @routes.size != 0 && @trains.size != 0
  
      request_for_route_number
  
      route_num = gets.to_i
  
      request_for_train_number
  
      train_num = gets.to_i
  
      if is_included?(@routes, route_num) && is_included?(@trains, train_num) #проверка выбора поезда и маршрута
        @trains[train_num - 1].get_route(@routes[route_num - 1])
        puts "Поезду #{@trains[train_num - 1].number} назначен маршрут #{@routes[route_num - 1].route_stations[0].name} - #{@routes[route_num - 1].route_stations[-1].name}"
      else
        puts 'Необходимо указать порядковый номер поезда и маршрута из списка'
      end
    end
  end

  def add_cars
    trains?
    
    if @trains.size != 0

      car_choice = 0

      while (car_choice != 1) && (car_choice != 2)

        puts 'Выберите тип вагона: 1. Пассажирский
              2. Грузовой'
        car_choice = gets.chomp.to_i

        if car_choice == 1
          car = PassengerCar.new
        elsif car_choice == 2
          car = CargoCar.new
        else
          puts 'Необходимо выбрать тип вагона'
        end
      end
  
      request_for_train_number
      train_num = gets.to_i

      if is_included?(@trains, train_num)
        if @trains[train_num - 1].type == car.type

          @trains[train_num - 1].attach_car(car)
          puts "Поезду #{@trains[train_num - 1].number} добавлен вагон.
          Количество вагонов в поезде: #{@trains[train_num - 1].cars.size}."
        else
          puts 'Тип вагона не соответствует типу поезда'
        end
      else
        puts 'Поезд с таким порядковым номером отсутствует'
      end
    end
  end


  def create_n_change_routes

    stations?
    
    if @stations.size != 0
  
      route_to_add = []
  
      while route_to_add.size < 2
  
        request_for_station_number
        station = gets.to_i #номер станции в списке
  
        if is_included?(@stations, station)
          route_to_add << @stations[station - 1]
        else
          puts 'Необходимо указать порядковый номер станции из списка'
        end
      end
  
      @routes << Route.new(route_to_add[0], route_to_add[1])
  
      loop do
  
        puts 'Хотите внести изменения в маршрут?
        1 - да, добавить станцию
        2 - да, удалить станцию
        нет - любое другое значение'
        choice = gets.to_i
  
        if choice == 1
          add_stations_to_route
  
        elsif choice == 2
          delete_stations_from_route
  
        else
          break
        end
      end
    end
  end

  def add_stations_to_route

    puts 'Введите номер промежуточной станции маршрута'
    @stations.each_with_index do |s, i|
      puts "#{i + 1} - #{s.name}"
    end

    station = gets.chomp.to_i
    unless @routes[-1].route_stations.include?(@stations[station-1])
      @routes[-1].add_intermediate_station(@stations[station-1])
    else
      puts 'Такая станция уже есть в данном маршруте'
    end
  end

  def delete_stations_from_route
    if @routes[-1].route_stations.size >= 3
      puts 'Введите номер станции маршрута, которую необходимо удалить:'
      @routes[-1].route_stations.each_with_index do |s, i| 
        puts "#{i + 1} - #{s.name}"
      end
      station_to_del = gets.chomp.to_i

      if is_included?(@routes[-1].route_stations, station_to_del)
        puts "Станция #{@routes[-1].route_stations[station_to_del - 1].name} удалена"
        @routes[-1].exclude_intermediate_station(station_to_del - 1)
      else
        puts 'Такая станция отсутствует в маршруте'
      end

    elsif @routes[-1].route_stations.size == 2
      puts 'Нельзя удалять станции из маршрута, если количество станций менее трех'
    
    end
  end

  def delete_cars
    trains?
  
    if @trains.size != 0
      request_for_train_number
      train_num = gets.to_i
        
      if is_included?(@trains, train_num)
        if @trains[train_num - 1].cars.size > 0
          @trains[train_num - 1].cars.delete_at(-1)
          puts "От поезда #{@trains[train_num - 1].number} отцеплен вагон.
          Количество вагонов в поезде: #{@trains[train_num - 1].cars.size}."
        else
          puts 'Отцеплять вагоны возможно только от поезда, количество вагонов которого не менее одного.'
        end
      else
        puts 'Необходимо указать порядковый номер поезда из списка'
      end
    end
  end


  def move_train

    trains_with_routes_qty = (@trains.size - @trains.count { |t| t.route.nil? })

    if trains_with_routes_qty == 0
      puts 'Ни одному поезду не присвоен маршрут'
    end

    if trains_with_routes_qty != 0

      if trains_with_routes_qty == 1
        train_to_move = @trains.select { |t| t.route }
        train_to_move = train_to_move[0]
        puts "Единственный поезд с присвоенным маршрутом: #{train_to_move.number}"
      else
        loop do
          trains_with_routes #запрос номера поезда, который перемещаем
          train_num = gets.to_i
          if @trains[train_num - 1].route
            train_to_move = @trains[train_num - 1]
            break
          else
            puts 'Необходимо указать порядковый номер поезда из списка, которому присвоен маршрут'
          end
        end
      end

      loop do
        puts 'Куда переместить поезд?
        1. Вперед
        2. Назад
        0. Выход в главное меню'

        direction = gets.to_i

        case direction
        when 1
          train_to_move.move_forward
        when 2
          train_to_move.move_back
        when 0
          break
        end
      end
    end
  end

  def print_stations_n_trains

    if @stations.size == 0
      puts 'Список станций пуст'
    else
      puts 'Список станций:'
      @stations.each { |station| puts station.name }
    end
  
    if @trains.count { |t| t.route }  == 0 #if @stations.count { |s| s.name.match(name) } == 0
      puts 'На станциях отсутствуют поезда'
    else
      @trains.each do |train|
        if train.route
          puts "\n Поезд #{train.number} находится на станции #{train.route.route_stations[train.station_number].name}"
        end
      end
    end
  end
end