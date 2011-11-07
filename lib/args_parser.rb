
module ArgsParser

  def self.parse(args, default_from = nil, default_to = nil)
    text = args.shift

    from = args.shift
    to = args.shift

    if from.nil? && to.nil?
      from = default_from
      to = default_to

    elsif !from.nil? && to.nil?
      to = from
      from = default_to
    end

    return text, from, to
  end
end
