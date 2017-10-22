defmodule Pastry do
  @moduledoc """
  Documentation for Pastry.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Pastry.hello
      :world

  """
  def main(args) do
    IO.puts "Welcome to Pastry"
    numNodes=String.to_integer(Enum.at(args,0))
    numRequests=String.to_integer(Enum.at(args,1))
    #IO.puts(numNodes)
    #IO.puts(numRequests)
    nodeList=[]
    createNodes(numNodes, numRequests, nodeList, 1)
  end

  #To be called first time when nodes of the pastry are supposed to be created
  def createNodes(numNodes, numRequests, nodeList, nodeNo) when nodeNo<=numNodes do
    #IO.puts nodeNo
    x=pidMD5hash(nodeNo)
    Pastry.PastryNode.start_link(x)
    nodeList=[x|nodeList]
    createNodes(numNodes, numRequests, nodeList, nodeNo+1)
  end
  #to be called when all nodes are created
  def createNodes(numNodes, numRequests, nodeList, nodeNo) when nodeNo>numNodes do
    nodeList= Enum.sort(nodeList)
    #IO.inspect nodeList
    populateleafSet(0,numNodes,nodeList)
  end

  #populates the leafset of every node 
  def populateleafSet(nodeNo,numNodes, nodeList) when nodeNo<numNodes do
    :timer.sleep(1000)
    #4 smaller smaller leaves 4
    cond do
    nodeNo==0 -> smallerLeafSet=[nil,nil,nil,nil]; IO.puts 1
    nodeNo==1 -> smallerLeafSet=[nil,nil,nil,Enum.at(nodeList,nodeNo-1)]; IO.puts 2
    nodeNo==2 -> smallerLeafSet=[nil,nil,Enum.at(nodeList,nodeNo-2),Enum.at(nodeList,nodeNo-1)]; IO.puts 3
    nodeNo==3 -> smallerLeafSet=[nil,Enum.at(nodeList,nodeNo-3),Enum.at(nodeList,nodeNo-2),Enum.at(nodeList,nodeNo-1)]; IO.puts 4
    true -> smallerLeafSet=[Enum.at(nodeList,nodeNo-4),Enum.at(nodeList,nodeNo-3),Enum.at(nodeList,nodeNo-2),Enum.at(nodeList,nodeNo-1)] 
           IO.puts true
    end
    #4 larger smaller leaves
    largerLeafSet=[Enum.at(nodeList,nodeNo+4),Enum.at(nodeList,nodeNo+3),Enum.at(nodeList,nodeNo+2),Enum.at(nodeList,nodeNo+1)]
    Pastry.PastryNode.populateLeafSet(Enum.at(nodeList,nodeNo),smallerLeafSet,largerLeafSet)
    populateleafSet(nodeNo+1,numNodes, nodeList)
  end
  def populateleafSet(nodeNo,numNodes, nodeList) when nodeNo>=numNodes do
    unlimitedLoop
  end

  #calling an unlimited loop to keep main thread alive
  def unlimitedLoop() do
    unlimitedLoop()
  end

  #convert pid to its md5 hash
  def pidMD5hash(nodeNo)do
    :crypto.hash(:md5, Integer.to_string(nodeNo)) |> Base.encode16
  end

end
