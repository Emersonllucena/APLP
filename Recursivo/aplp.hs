import Text.Read

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

findState :: String -> [String] -> [String] -> Int
findState state universe path = findState' state universe 0 path

findState' :: String -> [String] -> Int -> [String] -> Int
findState' state universe index path
    | universe !! index == "END" = do
        let newState = universe !! readSpecialState state universe (index+1) path
        findState newState universe path

    | state == universe !! index = index
    | otherwise = findState' state universe (endOfState universe index) path

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
limpaTela = putStr (take 100 (cycle "\n"))

findSpecialState :: String -> [String] -> Int -> Int
findSpecialState state universe index =
    if universe !! index == state
        then index
        else findSpecialState state universe (index+4)

countAtribute :: String -> Int -> [String] -> Int
countAtribute _ 0 _ = 0
countAtribute atributo linha universe = do
    let qtd = read (universe !! linha)
    if qtd == 0
        then 0
        else countAtribute' atributo (linha+1) qtd universe

countAtribute' :: String -> Int -> Int -> [String] -> Int
countAtribute' _ _ 0 _ = 0
countAtribute' atributo linha qtd universe
    | universe!!linha == atributo++" +" = 1 + countAtribute' atributo (linha+1) (qtd-1) universe
    | universe!!linha == atributo++" -" = (-1) + countAtribute' atributo (linha+1) (qtd-1) universe
    | otherwise = countAtribute' atributo (linha+1) (qtd-1) universe

findAtribute :: String -> [String] -> [String] -> Int
findAtribute _ [] _ = 0
findAtribute atribute (p:path) universe = do
    let comeco = findState p universe (p:path)
    let options = read (universe !! (comeco+2)) :: Int
    let much = countAtribute atribute (comeco+options+3) universe
    much + findAtribute atribute path universe

readSpecialState :: String -> [String] -> Int -> [String] -> Int
readSpecialState state universe index path = do
    let comeco = findSpecialState state universe index
    let atributo = nextWord (universe !! (comeco+1)) ' '
    let qtd = takeOffWord atributo (universe!!(comeco+1))
    if findAtribute atributo path universe <= read qtd
        then comeco+2
        else comeco+3

getValue :: Maybe Int -> Int
getValue Nothing = 0
getValue (Just a) = a

readState :: String -> [String] -> [String] -> IO ()
readState "GAME_OVER" _ _ = main
readState state universe path = do
    let comeco = findState state universe path
    let ultimo = if not (null path) then last path else ""

    let newPath = if universe !! comeco /= ultimo
           then path ++ [universe !! comeco]
           else path

    let qtdOptions = read (universe !! (comeco+2))
    limpaTela
    putStr (universe !! (comeco + 1) ++ "\n")
    if qtdOptions > 1
        then readOptions universe (comeco+2)
        else putStr "\n\n1 - Continuar\n\n"

    next <- getLine
    let value = getValue (readMaybe next :: Maybe Int)

    if value > qtdOptions || value < 1
        then readState state universe path
        else readState (chooseOption universe (comeco+2) value) universe newPath


playGame :: IO ()
playGame = do
    file <- readFile "../decisions"
    let linhas = split file
    readState "tutorial" linhas []

showCredits :: IO ()
showCredits = do
    limpaTela
    putStrLn " ----------------------------------------- "
    putStrLn "| Universidade Federal de Campina Grande  |"
    putStrLn "| Departamento de Sistemas e Computação   |"
    putStrLn " ----------------------------------------- "
    putStrLn "| Paradigmas de Linguagens de Programação |"
    putStrLn " ----------------------------------------- "
    putStrLn "| Professor:                              |"
    putStrLn "| -- Everton Leandro                      |"
    putStrLn " ----------------------------------------- "
    putStrLn "| Time de Desenvolvimento:                |"
    putStrLn "| -- Daniel Mitre                         |"
    putStrLn "| -- Emerson Lucena                       |"
    putStrLn "| -- Gustavo Ribeiro                      |"
    putStrLn "| -- Rafael Guerra                        |"
    putStrLn "| -- Rerisson Matos                       |"
    putStrLn " ----------------------------------------- "
    main

main :: IO ()
main = do
    putStr "\n\n\n\n"
    putStrLn " -------------------------------- "
    putStrLn "|         Menu Principal         |"
    putStrLn " -------------------------------- "
    putStrLn "| 1 - Jogar                      |"
    putStrLn "| 2 - Créditos                   |"
    putStrLn "| 3 - Sair                       |"
    putStrLn " -------------------------------- "

    next <- getLine
    let value = getValue (readMaybe next :: Maybe Int)
    case value of
        1 -> playGame
        2 -> showCredits
        3 -> putStrLn "Obrigado por jogar :D"
        _ -> main
