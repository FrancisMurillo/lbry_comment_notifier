~w(rel plugins *.exs)
|> Path.join()
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Distillery.Releases.Config,
  default_release: :default,
  default_environment: Mix.env()

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"B6p>{FEM?_Gx(7~1>_{<U?WFp8S?a)EtVSO2hwZo?>BWWL&4OfCYh&bjcuSSg@f8"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"}ttYypPJpudym[_[j(`Nj/I%~*_:y896BbYy`l46IS.eghzV|lWP._U{=/t.WH^I"
  set vm_args: "rel/vm.args"

  set pre_start_hooks: "rel/hooks/pre_start"

  set config_providers: [
    {Toml.Provider, [path: "${RELEASE_ROOT_DIR}/config.toml"]}
  ]
  set overlays: [
    {:copy, "config/defaults.toml", "config.toml"}
  ]
end

release :lbry_comment_notifier do
  set version: current_version(:lbry_comment_notifier)
  set applications: [
    :runtime_tools,
    lbry_comment_notifier: :permanent,
  ]
end
