
nextWord :: String -> Char -> String
nextWord a sep = nextWord' a [] sep

nextWord' :: String -> String -> Char -> String
nextWord' [] b _ = b
nextWord' (x:xs) b sep =
    if x == sep
        then b
        else nextWord' xs (b++[x]) sep

takeOffWord :: String -> String -> String
takeOffWord [] (_:ys)     = ys
takeOffWord _ []          = []
takeOffWord (_:xs) (_:ys) = takeOffWord xs ys

split :: String -> [String]
split a = split' a []

split' :: String -> [String] -> [String]
split' [] y = y
split' x y =
    if b /= ""
        then b:split' (takeOffWord b x) y    {-usando cons para otimiza��o: equivalente a split' (takeOffWord b x) (y++[b])-}
        else split' (takeOffWord b x) y
    where b = nextWord x '\n'

findState :: String -> [String] -> Int
findState state universe = findState' state universe 0

findState' :: String -> [String] -> Int -> Int
findState' state universe index =
    if state == universe !! index
        then index
        else findState' state universe (endOfState universe index)

endOfState :: [String] -> Int -> Int
endOfState universe start = jumpLines universe (jumpLines universe (start+2))

jumpLines :: [String] -> Int -> Int
jumpLines universe from = from + read (universe !! from) + 1

showNextLines :: [String] -> Int -> Int -> IO ()
showNextLines _ _ 0 = putStr "\n"
showNextLines universe line qtd = showNextLines' universe line 1 qtd

showNextLines' :: [String] -> Int -> Int -> Int -> IO ()
showNextLines' universe line from to = do
    let estado = nextWord (universe !! line) ' '
    let texto = takeOffWord estado (universe!!line)
    if from > to
        then putStr "\n"
        else do
            putStr (show from ++ " - ")
            putStr (texto ++ "\n")
            showNextLines' universe (line+1) (from+1) to

chooseOption :: [String] -> Int -> Int -> String
chooseOption universe line opt = nextWord (universe !! (line+opt)) ' '

readOptions :: [String] -> Int -> IO ()
readOptions universe opts = do
    putStr "\n\n"
    let qtd = read (universe !! opts) :: Int
    showNextLines universe (opts+1) qtd


limpaTela :: IO ()
limpaTela = putStr (take 4 (cycle "\n"))

readState :: String -> [String] -> IO ()
readState state universe = do
    let comeco = findState state universe
    limpaTela
    putStr (universe !! (comeco + 1) ++ "\n")
    readOptions universe (comeco+2)
    next <- getLine
    readState (chooseOption universe (comeco+2) (read next :: Int)) universe

main :: IO ()
main = do
    file <- readFile "../decisions.txt"
    let linhas = split file
    readState "tutorial" linhas
