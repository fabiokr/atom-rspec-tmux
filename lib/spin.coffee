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
    @getEditor().getCursorBufferPosition().row + 1

  getCurrentPath: ->
    @getEditor().getPath()

  getRoot: ->
    currentPath = @getCurrentPath()
    paths = atom.project.getPaths()
    matches = (path for path in paths when currentPath.indexOf(path) >= 0)

    # Returns longest match
    return matches.sort((a, b) -> (b.length - a.length))[0]

  getProjectName: ->
    parts = @getRoot().split("/")
    return parts[parts.length - 1]

  run: ->
    project = @getProjectName()

    require('child_process')
      .exec("tmux send-keys -t \'#{project}\' C-z 'rspec -b #{@getCurrentPath()}:#{@getCurrentLine()}' Enter")

    require('child_process')
      .exec("tmux select-window -t '#{project}'")
