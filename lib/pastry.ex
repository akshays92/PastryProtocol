defmodule Pastry do
  
  def main(args) do
    IO.puts "Welcome to Pastry"
    numNodes=String.to_integer(Enum.at(args,0))
    numRequests=String.to_integer(Enum.at(args,1))
    #IO.puts(numNodes)
    #IO.puts(numRequests)

    #creating numNodes number of initial nodes
    nodeList=createNodes(numNodes, numRequests, [], 1)
    
    #populating leaves set for initial nodes
    randomStartNode=getRandomStartNode(nodeList)
    
    #Pastry.PastryNode.printNodes(randomStartNode)
    Pastry.PastryNode.route("hi",pidMD5hash(:rand.uniform(numNodes*2)),randomStartNode)

    unlimitedLoop

    
  end

  
  
  #To be called first time when nodes of the pastry are supposed to be created
  def createNodes(numNodes, numRequests, nodeList, nodeNo) when nodeNo<=numNodes do
    #IO.puts nodeNo
    x=pidMD5hash(nodeNo)
    Pastry.PastryNode.pastryInit(x,nil)
    nodeList=[x|nodeList]
    createNodes(numNodes, numRequests, nodeList, nodeNo+1)
  end
  #to be called when all nodes are created
  def createNodes(numNodes, numRequests, nodeList, nodeNo) when nodeNo>numNodes do
    Enum.sort(nodeList)
  end

  
  
  def populateleafSet(nodeList, smallerLeaf, largerLeaf) when smallerLeaf<=largerLeaf do
    mid=round(Float.floor((smallerLeaf+largerLeaf)/2))
    Pastry.PastryNode.newLeaves(Enum.at(nodeList,mid),populateleafSet(nodeList,smallerLeaf,mid-1),populateleafSet(nodeList,mid+1,largerLeaf))
    Enum.at(nodeList,mid)
  end
  def populateleafSet(nodeList, smallerLeaf, largerLeaf) when smallerLeaf>largerLeaf do
    nil
  end

  #calling an unlimited loop to keep main thread alive
  def unlimitedLoop() do
    :timer.sleep(:infinity)
  end

  #convert pid to its md5 hash
  def pidMD5hash(nodeNo)do
    :crypto.hash(:md5, Integer.to_string(nodeNo)) |> Base.encode16
  end

  def getRandomStartNode(nodeList) do
    populateleafSet(nodeList,0,Enum.count(nodeList)-1)
  end

end
