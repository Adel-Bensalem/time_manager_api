defmodule Api_TimeManager.Account do
  @moduledoc """
      The Account context.
  """

  import Ecto.Query, warn: false
  alias Api_TimeManager.Repo

  alias Api_TimeManager.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_params(params) do
    IO.inspect(params)  #Inspects and writes the given item to the device
    query = from u in User
    if (params["email"]) do
      query = from u in User, where: u.email == ^params["email"]
      if (params["username"]) do
        query = from u in User, where: u.email == ^params["email"], where: u.username == ^params["username"]
        Repo.all(query)
      else
        Repo.all(query)
      end
    else
      if (params["username"]) do
        query = from u in User, where: u.username == ^params["username"]
        Repo.all(query)
      else
        Repo.all(query)
      end
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
      user
      |> User.changeset(attrs)
      |> Repo.update()
    end
  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Api_TimeManager.Account.Clock

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clock{}, ...]

  """
  def list_clocks do
    Repo.all(Clock)
  end

  @doc """
  Gets a single clock.

  Raises `Ecto.NoResultsError` if the Clock does not exist.

  ## Examples

      iex> get_clock!(123)
      %Clock{}

      iex> get_clock!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clock!(id), do: Repo.get!(Clock, id)
  def get_clock_by_user!(id) do
    #Repo.get_by!(Clock, [user: id])
    query = from c in Clock, where: c.user_id == ^id
    Repo.all(query)
  end

  @doc """
  Creates a clock.

  ## Examples

      iex> create_clock(%{field: value})
      {:ok, %Clock{}}

      iex> create_clock(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end
  #this fucntion creates a clock for user
  def create_clock_for_user(user_id,attrs \\ %{}) do
    cuser = %{time: attrs["time"], status: attrs["status"], user_id: user_id}
    %Clock{}
    |> Clock.changeset(cuser)
    |> Repo.insert()
  end

  def check_endclock_create_workingtime(clock) do
    if (clock.status == true) do
      user = clock.user
      query = from c in Clock, where: c.user_id == ^user, where: c.status == true, order_by: c.time
      last_clocks = Repo.all(query)
      last_clock = List.first(last_clocks)
      startClock = last_clock.time
      endClock = clock.time
      if (clock != last_clock) do
        nParams = %{time: last_clock.time, status: false, user: last_clock.user}
        last_clock
        |> Clock.changeset(nParams)
        |> Repo.update()
        nParams = %{time: clock.time, status: false, user: clock.user}
        clock
        |> Clock.changeset(nParams)
        |> Repo.update()
        create_auto_workingtime(clock.user, startClock, endClock)
      end
    end
  end

  @doc """
  Updates a clock.

  ## Examples

      iex> update_clock(clock, %{field: new_value})
      {:ok, %Clock{}}

      iex> update_clock(clock, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Clock.

  ## Examples

      iex> delete_clock(clock)
      {:ok, %Clock{}}

      iex> delete_clock(clock)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clock(%Clock{} = clock) do
    Repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.

  ## Examples

      iex> change_clock(clock)
      %Ecto.Changeset{source: %Clock{}}

  """
  def change_clock(%Clock{} = clock) do
    Clock.changeset(clock, %{})
  end

  alias Api_TimeManager.Account.Workingtime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%Workingtime{}, ...]

  """
  def list_workingtimes do
    Repo.all(Workingtime)
  end

  def list_workingtimes(params) do
    if (params["start"]) do
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.start >= ^params["start"], where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.start >= ^params["start"])
      end
    else
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.end <= ^params["end"])
      else
        Repo.all(Workingtime)
      end
    end

  end

  @doc """
  Gets a single workingtime.

  Raises `Ecto.NoResultsError` if the Workingtime does not exist.

  ## Examples

      iex> get_workingtime!(123)
      %Workingtime{}

      iex> get_workingtime!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workingtime!(id), do: Repo.get!(Workingtime, id)

  def get_workingtime_by_user!(id) do
      query = from w in Workingtime, where: w.user_id == ^id
      Repo.all(query)
  end

  def get_workingtime_by_user!(id, params) do
    if (params["start"]) do
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.user_id == ^id, where: w.start >= ^params["start"], where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.user_id == ^id, where: w.start >= ^params["start"])
      end
    else
      if (params["end"]) do
        Repo.all(from w in Workingtime, where: w.user_id == ^id, where: w.end <= ^params["end"])
      else
        Repo.all(from w in Workingtime, where: w.user_id == ^id)
      end
    end
  end

  @doc """
  Creates a workingtime.

  ## Examples

      iex> create_workingtime(%{field: value})
      {:ok, %Workingtime{}}

      iex> create_workingtime(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  def create_workingtime_for_user(id, attrs \\ %{}) do
    wuser = %{start: attrs["start"], end: attrs["end"], user: id}
    %Workingtime{}
    |> Workingtime.changeset(wuser)
    |> Repo.insert()
    #%Workingtime{}
    #|> Workingtime.changeset(attrs)
  end

  def create_auto_workingtime(userId, clockStart, clockEnd) do
    obj = %{start: clockStart, end: clockEnd, user: userId}
    %Workingtime{}
    |> Workingtime.changeset(obj)
    |> Repo.insert()
  end

  @doc """
  Updates a workingtime.

  ## Examples

      iex> update_workingtime(workingtime, %{field: new_value})
      {:ok, %Workingtime{}}

      iex> update_workingtime(workingtime, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workingtime.

  ## Examples

      iex> delete_workingtime(workingtime)
      {:ok, %Workingtime{}}

      iex> delete_workingtime(workingtime)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

  ## Examples

      iex> change_workingtime(workingtime)
      %Ecto.Changeset{source: %Workingtime{}}

  """
  def change_workingtime(%Workingtime{} = workingtime) do
    Workingtime.changeset(workingtime, %{})
  end

end
