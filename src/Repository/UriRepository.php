<?php

namespace App\Repository;

use App\Entity\Uri;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Exception;
use Symfony\Bridge\Doctrine\RegistryInterface;

/**
 * @method Uri|null find($id, $lockMode = null, $lockVersion = null)
 * @method Uri|null findOneBy(array $criteria, array $orderBy = null)
 * @method Uri[]    findAll()
 * @method Uri[]    findBy(array $criteria, array $orderBy = null, $limit = null, $offset = null)
 */
class UriRepository extends ServiceEntityRepository
{
    public function __construct(RegistryInterface $registry)
    {
        parent::__construct($registry, Uri::class);
    }

    /**
     * @param $token
     * @return \App\Entity\Uri|null
     * @throws \Doctrine\ORM\NonUniqueResultException
     */
    public function findOneByToken($token): ?Uri
    {
        return $this->createQueryBuilder('u')
            ->andWhere('u.token = :token')
            ->setParameter('token', $token)
            ->getQuery()
            ->getOneOrNullResult()
        ;
    }

    /**
     * @param Uri $uri
     * @return bool|string
     */
    public function incrementTimesUsed(Uri $uri)
    {
        $response = false;
        try {
            $this->_em->persist($uri);
            $this->_em->flush();
            $response = true;
        } catch (Exception $e) {
            return 'An Error occurred during save: ' .$e->getMessage();
        }
        return $response;
    }
}
