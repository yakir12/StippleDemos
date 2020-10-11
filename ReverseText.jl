using Genie, Stipple

using GenieAutoReload
autoreload(pwd())

Base.@kwdef mutable struct Model <: ReactiveModel
  process::R{Bool} = false
  output::R{String} = ""
  input::R{String} = "Stipple"
end

model = Stipple.init(Model())

on(model.process) do _
  if (model.process[])
    model.output[] = model.input[] |> reverse
    model.process[] = false
  end
end

function ui()
  [
  page(
    root(model), class="container", title="Reverse text", [
      p([
        "Input "
        input("", @bind(:input), @on("keyup.enter", "process = true"))
      ])
      p(
        button("Reverse", @click("process = true"))
      )
      p([
        "Output: "
        span("", @text(:output))
      ])
    ]
  )
  GenieAutoReload.assets()
  ] |> html
end

route("/", ui)