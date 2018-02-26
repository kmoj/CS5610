defmodule TaskTracker.Job.Timeblock do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTracker.Job.Task
  alias TaskTracker.Job.Timeblock


  schema "timeblocks" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    belongs_to :task, Task

    timestamps()
  end

  @doc false
  def changeset(%Timeblock{} = timeblock, attrs) do
    timeblock
    |> cast(attrs, [:start, :end, :task_id])
    |> validate_required([:start, :end, :task_id])
  end
end
