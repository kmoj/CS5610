defmodule TaskTracker.JobTest do
  use TaskTracker.DataCase

  alias TaskTracker.Job

  describe "tasks" do
    alias TaskTracker.Job.Task

    @valid_attrs %{complete: true, description: "some description", time: 42, title: "some title"}
    @update_attrs %{complete: false, description: "some updated description", time: 43, title: "some updated title"}
    @invalid_attrs %{complete: nil, description: nil, time: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Job.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Job.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Job.create_task(@valid_attrs)
      assert task.complete == true
      assert task.description == "some description"
      assert task.time == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Job.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.complete == false
      assert task.description == "some updated description"
      assert task.time == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_task(task, @invalid_attrs)
      assert task == Job.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Job.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Job.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Job.change_task(task)
    end
  end

  describe "tasks" do
    alias TaskTracker.Job.Task

    @valid_attrs %{assingned_to: "some assingned_to", complete: true, description: "some description", time: 42, title: "some title"}
    @update_attrs %{assingned_to: "some updated assingned_to", complete: false, description: "some updated description", time: 43, title: "some updated title"}
    @invalid_attrs %{assingned_to: nil, complete: nil, description: nil, time: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Job.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Job.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Job.create_task(@valid_attrs)
      assert task.assingned_to == "some assingned_to"
      assert task.complete == true
      assert task.description == "some description"
      assert task.time == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Job.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.assingned_to == "some updated assingned_to"
      assert task.complete == false
      assert task.description == "some updated description"
      assert task.time == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_task(task, @invalid_attrs)
      assert task == Job.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Job.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Job.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Job.change_task(task)
    end
  end

  describe "tasks" do
    alias TaskTracker.Job.Task

    @valid_attrs %{assigned_to: "some assigned_to", complete: true, description: "some description", time: 42, title: "some title"}
    @update_attrs %{assigned_to: "some updated assigned_to", complete: false, description: "some updated description", time: 43, title: "some updated title"}
    @invalid_attrs %{assigned_to: nil, complete: nil, description: nil, time: nil, title: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Job.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Job.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Job.create_task(@valid_attrs)
      assert task.assigned_to == "some assigned_to"
      assert task.complete == true
      assert task.description == "some description"
      assert task.time == 42
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, task} = Job.update_task(task, @update_attrs)
      assert %Task{} = task
      assert task.assigned_to == "some updated assigned_to"
      assert task.complete == false
      assert task.description == "some updated description"
      assert task.time == 43
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_task(task, @invalid_attrs)
      assert task == Job.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Job.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Job.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Job.change_task(task)
    end
  end

  describe "timeblocks" do
    alias TaskTracker.Job.Timeblock

    @valid_attrs %{end: ~N[2010-04-17 14:00:00.000000], start: ~N[2010-04-17 14:00:00.000000]}
    @update_attrs %{end: ~N[2011-05-18 15:01:01.000000], start: ~N[2011-05-18 15:01:01.000000]}
    @invalid_attrs %{end: nil, start: nil}

    def timeblock_fixture(attrs \\ %{}) do
      {:ok, timeblock} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Job.create_timeblock()

      timeblock
    end

    test "list_timeblocks/0 returns all timeblocks" do
      timeblock = timeblock_fixture()
      assert Job.list_timeblocks() == [timeblock]
    end

    test "get_timeblock!/1 returns the timeblock with given id" do
      timeblock = timeblock_fixture()
      assert Job.get_timeblock!(timeblock.id) == timeblock
    end

    test "create_timeblock/1 with valid data creates a timeblock" do
      assert {:ok, %Timeblock{} = timeblock} = Job.create_timeblock(@valid_attrs)
      assert timeblock.end == ~N[2010-04-17 14:00:00.000000]
      assert timeblock.start == ~N[2010-04-17 14:00:00.000000]
    end

    test "create_timeblock/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Job.create_timeblock(@invalid_attrs)
    end

    test "update_timeblock/2 with valid data updates the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, timeblock} = Job.update_timeblock(timeblock, @update_attrs)
      assert %Timeblock{} = timeblock
      assert timeblock.end == ~N[2011-05-18 15:01:01.000000]
      assert timeblock.start == ~N[2011-05-18 15:01:01.000000]
    end

    test "update_timeblock/2 with invalid data returns error changeset" do
      timeblock = timeblock_fixture()
      assert {:error, %Ecto.Changeset{}} = Job.update_timeblock(timeblock, @invalid_attrs)
      assert timeblock == Job.get_timeblock!(timeblock.id)
    end

    test "delete_timeblock/1 deletes the timeblock" do
      timeblock = timeblock_fixture()
      assert {:ok, %Timeblock{}} = Job.delete_timeblock(timeblock)
      assert_raise Ecto.NoResultsError, fn -> Job.get_timeblock!(timeblock.id) end
    end

    test "change_timeblock/1 returns a timeblock changeset" do
      timeblock = timeblock_fixture()
      assert %Ecto.Changeset{} = Job.change_timeblock(timeblock)
    end
  end
end
