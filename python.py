from PIL import Image

## exception
try:
    message = daemon.receive()
    assert(message.HasField("init"))
except Queue.Empty:
    pass
except Exception as inst:
    assert False, "Unexpected exception: " + str(type(inst)) + " | " + str(inst)
else:
    assert False, "Recieve 'init' message while use invalid login/password"
finally:
    pass


