##
# Resets an object's (instance, class, or module) attribute to the original 
# value after block execution.
#
def without_changing(object, attribute, &block)
  original = object.send(attribute)
  yield
  object.send("#{attribute}=", original)
end
