require './parking'

class ParkingLot
  attr_accessor :allocated_slot, :parking_number, :parking_lot, :run

  def initialize
    @allocated_slot = 0
    @parking_number = 0
    @parking_lot = []
    @run = false
  end

  def create_parking_lot(input)
    if input[1].nil? || input[1].to_i == 0
      puts "\nPlease enter valid number greater than 0"
    else
      @allocated_slot = input[1].to_i
      puts "\nCreated a parking lot with #{@allocated_slot} slots"
    end
  end

  def park_car(input)
    parking = Parking.new

    if @parking_lot.length < @allocated_slot
      if @parking_lot.count == 0
        parking.create_parking_lot(@parking_number + 1, input[1], input[2])
        @parking_lot.push(parking)
      else
        if @parking_lot.find {|park| park.registration_no == input[1]}
          puts "\nCar with the given registration number is already parked."
        else
          all_slots = @parking_lot.map {|park| park.slot_no}
          all_slots = all_slots.sort
          for i in 1..@allocated_slot
            if !all_slots.include? i
              parking.create_parking_lot(i, input[1], input[2])
              @parking_lot.push(parking)
              break
            end
          end
        end
      end
    else
      puts "\nSorry, parking lot is full"
    end
  end

  def status_dashboard
    puts "\n slot_no\t|\tregistration_no\t|\tcolour "

    @parking_lot = @parking_lot.sort { |x, y| x.slot_no <=> y.slot_no }
    @parking_lot.each do |lot|
      puts "    #{lot.slot_no}\t\t\t    #{lot.registration_no}\t\t\t    #{lot.colour} "
    end

    puts "\n"
  end

  def leave_slot_number(input)
    if input[1].nil? || input[1].to_i == 0
      puts "\nPlease enter a valid number greater than 0"      
    else
      @parking_lot.delete_if {|lot| lot.slot_no.to_s == input[1].to_s }
      puts "\nSlot number #{input[1]} is free"
    end
  end

  def registration_numbers_for_cars_with_colour(input)
    @parking_lot.each do |lot|
      if lot.colour == input[1]
        puts lot.registration_no
      end
    end
  end

  def slot_numbers_for_cars_with_colour(input)
    data = []
    
    @parking_lot.each do |lot|
      if lot.colour == input[1]
        data.push(lot.slot_no)
      end
    end
    
    output_data(data)
  end

  def slot_number_for_registration_number(input)
    data = []

    @parking_lot.each do |lot|
      if lot.registration_no == input[1]
        data.push(lot.slot_no)
      end
    end
   
    output_data(data)
  end

  def start
    argv = ARGV
    while(@run == false) do
      if argv.empty?
        
        if @allocated_slot == 0
          puts "\nType command to view all commands"
        else
          puts "\nType a command to execute:"
        end
        input = gets.split(" ")
      else
        cmd = gets
        break if cmd.nil?
        argv = 'ok'

        input = cmd.split(" ")
        puts "Input:"
        puts cmd
      end

      if input[0] == 'command'
        puts "1. create_parking_lot"
        puts "2. park"
        puts "3. leave"
        puts "4. status"
        puts "5. registration_numbers_for_cars_with_colour"
        puts "6. slot_numbers_for_cars_with_colour"
        puts "7. slot_number_for_registration_number"
      else
        if @allocated_slot == 0 && input[0] != 'create_parking_lot'
          puts "\nPlease enter parking lot space before proceeding with further commands"
        else 
          case input[0]
          when "create_parking_lot"
            create_parking_lot(input)
          when "park"
            park_car(input)
          when "leave"
            leave_slot_number(input)
          when "status"
            status_dashboard
          when "registration_numbers_for_cars_with_colour"
            registration_numbers_for_cars_with_colour(input)
          when "slot_numbers_for_cars_with_colour"
            slot_numbers_for_cars_with_colour(input)
          when "slot_number_for_registration_number"
            slot_number_for_registration_number(input)
          else
            puts "Wrong command\n"
          end
        end
      end

    end
  end

  private

  def output_data(data)
    puts "\nOutput:"
    
    if data.empty?
      puts "not found"
    else
      puts data.join(', ')
    end
    
    puts "\n"
  end
end
