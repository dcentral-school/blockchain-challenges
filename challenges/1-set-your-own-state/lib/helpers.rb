Thread.abort_on_exception = true

def every(seconds)
  Thread.new do
    loop do
      sleep seconds
      yield
    end
  end
end

def render_state
  puts "-" * 40
  STATE.to_a.sort_by(&:first).each do |host, (band, version_number)|
    puts "#{host.green} currently likes #{band.yellow}"
  end
  puts "-" * 40
end

def update_state(update)
  update.each do |host, (band, version_number)|
    next if host.nil?

    if [band, version_number].any?(&:nil?)
      STATE[host] ||= nil
    else
      STATE[host] = [STATE[host], [band, version_number]].compact.max_by(&:last)
    end
  end
end
