class Museum
  attr_reader :name, :exhibits, :patrons, :grouped

  def initialize(name)
    @name = name
    @exhibits = {}
    @patrons = []
  end

  def add_exhibit(exhibit, cost)
    @exhibits[exhibit] = cost
  end

  def admit(patron)
    @patrons << patron
  end

  def revenue
    total = 0
    @patrons.each do |patron|
      patron.interests.each do |interest|
        total += @exhibits[interest] if @exhibits.keys.include?(interest)
      end
    end
    total += (@patrons.count) * 10
  end

  def patrons_of(exhibit)
    patrons_of = []
    @patrons.each do |patron|
      patron.interests.each do |interest|
        patrons_of << patron.name if @exhibits.keys.include?(interest)
      end
    end.map { |patron| patron.name }
  end

  def exhibits_by_attendees
    exhibits = @exhibits.keys
    interests = []
    @patrons.each do |patron|
      patron.interests.each do |interest|
        interests << interest if exhibits.include?(interest)
      end
    end
    grouped(interests)
  end

  def grouped(interests)
    @grouped = interests.inject(Hash.new(0)) do |hash, interest|
      hash[interest] += 1
      hash
    end
    to_sort = @grouped
    organize(to_sort)
  end

  def organize(to_sort)
    to_sort.sort_by {|key, value| value }.reverse.to_h.keys
  end

  def remove_unpopular_exhibits(threshold)
    exhibits_by_attendees
    @grouped.delete_if do |key, value|
      value < threshold
    end
    @grouped.keys
  end






end
