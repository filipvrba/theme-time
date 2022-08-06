def absolute_path relative_path
  File.absolute_path(relative_path, __FILE__)
end

def pid_term
  %x(pgrep -f theme-time)
end
