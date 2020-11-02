class UnsupportedDecimalSelector < StandardError; end
class InsufficientArguments < StandardError; end
class InvalidToken < StandardError; end
class InvalidExpression < StandardError; end

class PolandCalculator

  def initialize (&block)
    @decimal_selector = :d_2 # default
    instance_eval &block if block_given?
    @stack = Array.new
  end

  def decimal_selector(dec)
    @decimal_selector = dec
  end

  def functions(&block)
    @fns = block
  end

  def token_type (tok)
    if tok.match(/^\-?([0-9]+\.?[0-9]*)|([0-9]*\.[0-9]+)$/) then
      return :number
    elsif tok =~ /^f_\w+$/ then
      return :function
    elsif tok =~ /^[\+\-\*\/]$/ then
      return :operator
    else
      return :invalid
    end
  end

  def calc (str)
    @stack.clear

    return if str.nil?

    case @decimal_selector
    when :d_0, :d_2, :d_float
    else
      puts '>>'+@decimal_selector+'<<'
      raise UnsupportedDecimalSelector, "Unsupported decimal selector"
    end

    # prepare functions (not sure if this is a good way to do it but it works)
    str.split(' ').each do |fn|
      if token_type(fn) == :function
        singleton_class.define_method(fn) do |lmb|
          singleton_class.define_method("f"+fn) do |arg|
            result = lmb.call(arg)
            return result
          end
        end
      end
    end

    if @fns != nil then
      instance_eval &@fns
    end

    # process
    str.split(' ').each do |tok|
      case token_type(tok)
      when :operator
        if @stack.length < 2 then
          raise InsufficientArguments, "Insufficient arguments for #{tok}"
        end
        right = @stack.pop
        left = @stack.pop
        result = case tok
            when "+"
              left + right
            when "-"
              left - right
            when "*"
              left * right
            when "/"
              left / right
            end        
        @stack.push result
      when :number
        @stack.push tok.to_f
      when :function
        if @stack.length < 1 then
          raise InsufficientArguments, "Insufficient arguments for #{tok}"
        end
        val = @stack.pop
        result = instance_eval "f"+tok+" "+val.to_s # logged inside
        @stack.push result
      else
        raise InvalidToken, "Invalid token #{tok}"
      end
    end

    if @stack.length > 1 then
      raise InvalidExpression, "Invalid expression"
    end

    result = @stack.pop

    case @decimal_selector 
    when :d_0
      result = result.round(0)
    when :d_2
      result = result.round(2)
    end
    return result
  end
end

=begin
pc = PolandCalculator.new do
  functions do
    f_x -> (x) { 1.0 / x }
    f_my_function -> (x) { 0.99 + x }
  end
  decimal_selector :d_2
end
puts pc.calc('1. 1 + f_my_function f_x 2 +')
=end
