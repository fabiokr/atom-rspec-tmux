{CompositeDisposable} = require 'atom'

module.exports = Spin =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'spin:run': => @run()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  getEditor: ->
    atom.workspace.getActiveTextEditor()

  getCurrentLine: ->
    @getEditor().getCursorBufferPosition().row

  getCurrentPath: ->
    @getEditor().getPath()

  getRoot: ->
    currentPath = @getCurrentPath()
    paths = atom.project.getPaths()
    matches = (path for path in paths when currentPath.indexOf(path) >= 0)

    # Returns longest match
    return matches.sort((a, b) -> (b.length - a.length))[0]

  run: ->
    require('child_process')
      .exec("spin push #{@getCurrentPath()}:#{@getCurrentLine()}", { cwd: @getRoot() })
