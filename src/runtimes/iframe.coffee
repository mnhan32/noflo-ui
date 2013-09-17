Base = require './base'

class IframeRuntime extends Base
  constructor: (dataflow, graph, iframe) ->
    @iframe = iframe
    @origin = window.location.origin
    super dataflow, graph

  sendGraph: (command, payload) ->
    @send 'graph', command, payload
  sendNetwork: (command, payload) ->
    @send 'network', command, payload
  sendComponent: (command, payload) ->
    @send 'component', command, payload

  getFrameWindow: ->
    @iframe.contentWindow

  send: (protocol, command, payload) ->
    w = @getFrameWindow()
    if not w or w.location.href is 'about:blank'
      console.log 'IGNORE', command
      return
    w.postMessage
      protocol: protocol
      command: command
      payload: payload
    , w.location.href

  connect: (protocol) ->
    window.addEventListener 'message', @onMessage, false

  disconnect: (protocol) ->
    window.removeEventListener 'message', @onMessage, false

  onMessage: (message) =>
    switch message.data.protocol
      when 'graph' then @recvGraph message.data.command, message.data.payload
      when 'network' then @recvNetwork message.data.command, message.data.payload
      when 'component' then @recvComponent message.data.command, message.data.payload

module.exports = IframeRuntime
