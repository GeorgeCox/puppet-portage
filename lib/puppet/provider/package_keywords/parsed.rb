File.expand_path('../..', File.dirname(__FILE__)).tap { |dir| $:.unshift(dir) unless $:.include?(dir) }
require 'puppet/provider/portagefile'
require 'puppet/util/portage'

Puppet::Type.type(:package_keywords).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.keywords/default",
  :filetype => :flat
) do

  desc "The package_keywords provider that uses the ParsedFile class"
  text_line :comment, :match => /^\s*#/
  text_line :blank, :match => /^\s*$/
  record_line :parsed, :fields => %w{name keywords}, :joiner => ' ', :rts => true do |line|
    Puppet::Provider::PortageFile.process_line(line, :keywords)
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed
    build_line(hash, :keywords)
  end
end
